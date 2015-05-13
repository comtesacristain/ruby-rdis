namespace :duplicate_manager do
  desc "TODO"
  task run_all: :environment do
    run_all
  end
  
  task find_and_rank: :environment do
    find_and_rank
  end
  
  desc "TODO"
  task load_boreholes: :environment do
    load_boreholes
  end
  
  desc "TODO"
  task find_duplicates: :environment do
    find_duplicates
  end

  desc "TODO"
  task update_duplicates: :environment do
    update_duplicates
  end

  desc "TODO"
  task rank_duplicates: :environment do
    rank_duplicates
  end
  
  desc "TODO"
  task load_spreadsheet: :environment do
    load_spreadsheet
  end

end

  

def run_all
  load_boreholes
  if Handler.where.not(:or_status=>nil).empty?
    load_spreadsheet
  end
  find_and_rank
end

def find_and_rank
  distance_queries.each do |d|
     find_duplicates(d)
     rank_duplicates
  end
end

def load_boreholes(n=num)
  connection=OCI8.new(db["oracle_production"]["username"],db["oracle_production"]["password"],db["oracle_production"]["database"])
  statement = "select #{query_string} from a.entities e where entity_type in ('DRILLHOLE', 'WELL')"
  unless n.nil?
    statement = statement + " and rownum < #{n}"
  end
  statement += " order by eno"
  cursor=connection.exec(statement)
  cursor.fetch_hash do |row|
    borehole=Borehole.find_or_initialize_by(eno:row["ENO"])
    borehole.update(borehole_attr_hash(row))
    handler = Handler.new
    borehole.handler = handler
    borehole.save
    puts "Loaded borehole: %s" % row["ENO"]
  end
end

def load_spreadsheet 
  spreadsheet = 'duplicate_boreholes_analysis_Jan2015.xlsx'
  wb =Roo::Spreadsheet.open(spreadsheet)
  sheet = wb.sheet(0)
  ((sheet.first_row + 1)..sheet.last_row).each do |row|
    eno = sheet.row(row)[1]
    orc = sheet.row(row)[4]
    borehole = Borehole.find_by(:eno=>eno)
    unless borehole.nil?
      if borehole.handler.nil?
        handler=Handler.new
        handler.borehole=borehole
      else
        handler = borehole.handler
      end
      handler.or_comment = orc
      case orc
      when /possibl|probabl/i
        handler.or_status = "possibly"
      when /duplicate/i
        handler.or_status = "duplicate"
      when "no"
        handler.or_status = "no"
      when nil
        handler.or_status = "undetermined"
      else
        handler.or_status = "other"
      end
      handler.save
    else
      if Rails.env == "production"
        puts "Borehole #{eno} not a DRILLHOLE or WELL"
      end
      
    end
    puts "#{eno}, #{orc}"
  end
end

def find_duplicates(d=0)
  kind = "#{d}m"
  connection=OCI8.new(db["oracle_production"]["username"],db["oracle_production"]["password"],db["oracle_production"]["database"])
  boreholes=Borehole.joins(:handler).where(Handler.arel_table[:or_status].not_eq("no").and(Handler.arel_table[:auto_remediation].eq(nil)))
  boreholes.each do |borehole|
    puts "Searching for duplicates around borehole #{borehole.eno} with within #{d} metres"
    geom = borehole.geom
    unless geom == "NULL"
      statement=spatial_query(geom,d)
      
      cursor = connection.exec(statement)
      duplicates = Array.new
      cursor.fetch_hash{ |r| duplicates.push(r)}
      if duplicates.size >1
        name_duplicates = group_by_name(duplicates)
        name_duplicates.each do |nd|
          insert_duplicates(nd,kind)
        end
      end
    end
  end
end

def group_by_name(duplicates)
  names=duplicates.map{|d| d["ENTITYID"]}
  puts "Grouping names: #{names.join(',')}"
  nh = names_hash(names)
  grouped_names = nh.values.select{|v| v.size > 1}
  named_duplicates =Array.new
  grouped_names.each do |n|
    named_duplicates.push(duplicates.select{|hash| n.include?(hash["ENTITYID"])})
  end
  return named_duplicates
end
  

def insert_duplicates(duplicates,kind='100m')
  enos = duplicates.map{|d| d["ENO"]}
  puts "Inserting boreholes into database with enos #{enos.join(',')}"
  duplicate_groups = Duplicate.includes(:boreholes).where(boreholes:{eno:enos}) #,kind:kind
  if duplicate_groups.exists?
    duplicate_group=duplicate_groups.first
  else
    duplicate_group = Duplicate.new(:has_remediation=>'N',:kind=>kind)
  end
  duplicates.each do | d |
    borehole = Borehole.find_by(eno:d["ENO"])
    if borehole.nil?
      borehole=Borehole.create(borehole_attr_hash(d))
      handler= Handler.new
      borehole.handler = handler # Each borehole must come with a handler
      borehole.save
    end
    borehole_duplicates=borehole.borehole_duplicates.where(duplicate:duplicate_group)
    if borehole_duplicates.empty?
      borehole_duplicate = borehole.borehole_duplicates.build(duplicate:duplicate_group)
      borehole_duplicate.save
    end
  end
  duplicate_group.save
end

def update_duplicates

  connection=OCI8.new(db["oracle_production"]["username"],db["oracle_production"]["password"],db["oracle_production"]["database"])
  boreholes = Borehole.all
  boreholes.each do |borehole|
    statement = "select #{query_string} from a.entities e where eno =#{borehole.eno}"
    cursor=connection.exec(statement)
    row = cursor.fetch_hash
    borehole.update(borehole_attr_hash(row))
    borehole.save
  end
end

def rank_duplicates
  duplicate_groups=Duplicate.all
  duplicate_groups.each do |duplicate_group|
    boreholes = duplicate_group.boreholes
      name_sort(boreholes)
      auto_remediations = duplicate_group.boreholes.includes(:handler).pluck(:auto_remediation)
      if "DELETE".in?(auto_remediations)
        duplicate_group.update(:has_remediation=>'Y')
      else
        duplicate_group.update(:has_remediation=>'N')
      end
  end

end



=begin
  TODO: List of duplicate_ids to test: 
  2: Palmerston 1 - Case check
  11: Jamison-1 - remove hyphen
  90: BMR Mount Whelan 1 - drop BMR, excpand Mt
  1334: SH 5302 - search only on number
  1372: BMR Winning Pool No. 1 - remove space 
 
=end

def name_sort(boreholes)
  names = names_hash(boreholes.pluck(:entityid).uniq)
  if names.size > 1
    names.each do |k,v|
      name_sort(boreholes.where(:entityid=>v))
    end
  else
    rank_set(boreholes)
  end
end


def rank_set(boreholes)
  if boreholes.size > 1
    types =  boreholes.pluck(:entity_type).uniq
    if types.size > 1
      well_set = boreholes.where(:entity_type=>'WELL')
      drillhole_set = boreholes.where(:entity_type=>'DRILLHOLE')
      if well_set.size > 1
        well = rank_set(well_set)
      else
        well = well_set.first
      end
      drillhole_set.each {|b| b.handler.update({:auto_remediation=>"DELETE",:auto_transfer=>well.eno})}
      well.handler.update(:auto_remediation=>'KEEP',:auto_transfer=>nil)
      return well
    else
      if has_relations(boreholes)
        boreholes.each { |b| b.handler.update({:auto_remediation=>"NONE",:auto_transfer=>nil})}
        return nil
      else
        dates =  Hash[boreholes.map {|b| [b.eno, b.entity.entrydate]}]
        eno = dates.key(dates.values.min)
        delete=boreholes.where(Borehole.arel_table[:eno].not_in eno)
        delete.each {|b|  b.handler.update({:auto_remediation=>"DELETE",:auto_transfer=>eno})}
        keep=boreholes.where(:eno=>eno).first
        keep.handler.update(:auto_remediation=>'KEEP')
        return keep
      end
    end
  else
    boreholes.first.handler.auto_remediation="NONE"
    boreholes.first.handler.save
    return nil
  end
end


def has_relations(boreholes)
  enos = boreholes.pluck(:eno)
  parents = boreholes.pluck(:parent).compact
  if !parents.empty? and parents.all?{|e| enos.include?(e)}
    return parents.all?{|e| enos.include?(e)}
  end
  associated_well_enos =Array.new
  boreholes.each do |b|
    unless b.entity.well.nil?
      associated_well_enos.push(b.entity.well.well_confids.pluck(:associated_well_eno).uniq)
    end
  end
  associated_well_enos = associated_well_enos.flatten.compact
  unless associated_well_enos.empty?
    associated_well_enos.map!{|e| e.to_i}
    return associated_well_enos.all?{|e| enos.include?(e)}
  else
    return false
  end
end

=begin

=end


def names_hash(names)
  return names.group_by {|n| parse_string(n) }
end

def parse_string(s)
  if s =~ /BMR/
    s=s.gsub(/BMR /,"")
  end
  if s =~ /Mt/
    s=s.gsub(/Mt/,"Mount")
  end
  if s =~ /no\. ?/i
    s=s.gsub(/no\. ?/i,"")
  end
  if s =~ /[\W_]+/
    s=s.gsub(/[\W_]+/," ")
  end
  if s =~ /O(?=[0-9])/
    s=s.gsub(/O(?=[0-9])/,"0")
  end
  if s =~ /(?<=[A-Z])+0+/
    s=s.gsub(/(?<=[A-Z])+0+/,"")
  
  end
  return s.downcase.gsub(/ /,'')
end

def to_sdo_string(sdo)
  if sdo.nil?
    return "NULL"
  else
    geom=sdo.instance_variable_get("@attributes")
    case sdo.class.to_s
    when "OCI8::Object::Mdsys::SdoGeometry"
      
      gtype=geom[:sdo_gtype]
      point = to_sdo_string(geom[:sdo_point])
      srid = geom[:sdo_srid]
      element_info = to_sdo_string(geom[:sdo_elem_info])
      ordinates = to_sdo_string(geom[:sdo_ordinates])
      return "SDO_GEOMETRY(#{gtype},#{srid},#{point},#{element_info},#{ordinates})"
    when "OCI8::Object::Mdsys::SdoPointType"
      if geom[:z].nil?
        return "SDO_POINT_TYPE(#{geom[:x]},#{geom[:y]},NULL)"
      else
        return "SDO_POINT_TYPE(#{geom[:x]},#{geom[:y]},#{geom[:z]})"
      end
    end
  end
end

def borehole_attr_hash(row)
  h =Hash.new
  query_terms.each do |qt|
    if qt == :geom
      if row[qt.to_s.upcase].nil?
        geom_hash = {geom:to_sdo_string(row[qt.to_s.upcase]),x:nil,y:nil,z:nil}
      else
        geometry=row[qt.to_s.upcase].instance_variable_get("@attributes")
        geom_hash = {geom:to_sdo_string(row[qt.to_s.upcase]),x:geometry[:sdo_point].instance_variable_get("@attributes")[:x],y:geometry[:sdo_point].instance_variable_get("@attributes")[:y],z:geometry[:sdo_point].instance_variable_get("@attributes")[:z]}
      end
      h.merge!(geom_hash)
    elsif qt == :geom_original
      h[qt] = to_sdo_string(row[qt.to_s.upcase])
    else
      h[qt] = row[qt.to_s.upcase]
    end
  end
  return h
end

def num
  if Rails.env == "development"
    return 1000
  else 
    return nil
  end
end

def db
  return YAML.load_file('config/database.yml')
end

def query_terms
  return [:eno, :entityid, :entity_type, :geom, :access_code, :confid_until,:qa_status_code,:qadate,:acquisition_methodno,:geom_original,:parent,:remark,:eid_qualifier]
end

def query_string
  return query_terms.join(",")
end


def spatial_query(geom,d=100)

  return "select #{query_string} from a.entities e where sdo_within_distance(e.geom,#{geom},'distance= #{d},units=m')='TRUE' and entity_type in ('DRILLHOLE','WELL')"
end



def distance_queries 
  return [0,100,1000,5000]
end
