namespace :duplicate_manager do
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
  task read_spreadsheet: :environment do
    read_spreadsheet
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



def spatial_query
  return "select #{query_string} from a.entities e where sdo_within_distance(e.geom,%{geom},'distance= 100,units=m')='TRUE' and entity_type in ('DRILLHOLE','WELL')"
end

def find_duplicates
  connection=OCI8.new(db["production"]["username"],db["production"]["password"],db["production"]["database"])
  cursor=connection.exec("select eno, entityid, geom, entity_type from a.entities where entity_type in ('DRILLHOLE', 'WELL') and geom is not null order by eno") 
    cursor.fetch_hash do |row|
      puts row["ENO"]
      geom = to_sdo_string(row["GEOM"])
      statement=spatial_query % {:geom=>geom}
      results=connection.exec(statement)
      duplicates = Array.new
      results.fetch_hash{ |r| duplicates.push(r)}
      if duplicates.count > 1
        insert_duplicates(duplicates)
      end
    end
end

def insert_duplicates(duplicates) 
  enos = duplicates.map{|d| d["ENO"]}
  duplicate_groups = Duplicate.includes(:boreholes).where(boreholes:{eno:enos}) #
  if duplicate_groups.exists?
    duplicate_group=duplicate_groups.first
  else
    duplicate_group = Duplicate.new(:has_remediation=>'N')
  end
  duplicates.each do | d |

    boreholes = Borehole.where(eno:d["ENO"])
      if boreholes.exists?
        borehole = boreholes.first
      else
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


def load_boreholes 
  connection=OCI8.new(db["production"]["username"],db["production"]["password"],db["production"]["database"])
  statement = "select #{query_string} from a.entities e where entity_type in ('DRILLHOLE', 'WELL')"
  cursor=connection.exec(statement)
  cursor.fetch_hash do |row|
    
    borehole=Borehole.find_or_initialize_by(eno:row["eno"])
    borehole.update(borehole_attr_hash(row))
    if borehole.handler.nil?
      handler = Handler.new
      borehole.handler = handler
    end
    borehole.save
  end
end



def update_duplicates

  connection=OCI8.new(db["production"]["username"],db["production"]["password"],db["production"]["database"])
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
      auto_rank(boreholes)
      #or_rank(boreholes)
      auto_remediations = duplicate_group.boreholes.includes(:handler).pluck(:auto_remediation)
      if "DELETE".in?(auto_remediations)
        duplicate_group.update(:has_remediation=>'Y')
      else
        duplicate_group.update(:has_remediation=>'N')
      end
  end
  
  duplicates=Duplicate.where(:has_remediation=>'N')
  duplicates.each do |d|
    boreholes=d.boreholes
    if boreholes.count ==2 
      statuses =boreholes.includes(:handler).pluck(:or_status)
      if !statuses.include?("no")  and statuses.include?("duplicate")
        rank_set(boreholes)
      end
    end
    auto_remediations = d.boreholes.includes(:handler).pluck(:auto_remediation)
    if "DELETE".in?(auto_remediations)
      d.update(:has_remediation=>'Y')
    else
      d.update(:has_remediation=>'N')
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

def auto_rank(boreholes)
  names = names_hash(boreholes.pluck(:entityid).uniq)
  puts "Sorting the following: #{names}"
  if names.size > 1
    names.each do |k,v|
      puts "#{names.size} duplicates detected. Splitting ..."
      auto_rank(boreholes.where(:entityid=>v))
    end
  else
    rank_set(boreholes)
  end
end


def rank_set(boreholes)
  puts "1 duplicate detected"
  if boreholes.size > 1
    puts "#{boreholes.size} boreholes detected ..."
    types =  boreholes.pluck(:entity_type).uniq
    puts "Types: #{types}"
    if types.size > 1
      puts "#{types.size} types detected" 
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

def read_spreadsheet 
  spreadsheet = 'duplicate_boreholes_analysis_Jan2015.xlsx'
  wb =Roo::Spreadsheet.open(spreadsheet)
  sheet = wb.sheet(0)
  ((sheet.first_row + 1)..sheet.last_row).each do |row|
    eno = sheet.row(row)[1]
    orc = sheet.row(row)[4]
    borehole = Borehole.where(:eno=>eno).first
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
        handler.or_status = "none"
      else
        handler.or_status = "other"
      end
      handler.save
    else
      puts "#{eno}, #{orc}"
    end
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
      puts b.entity.well.well_confids.pluck(:associated_well_eno)
      associated_well_enos.push(b.entity.well.well_confids.pluck(:associated_well_eno).uniq)
    end
  end
  associated_well_enos.flatten!
  unless associated_well_enos.empty?
    associated_well_enos.compact!.map!{|e| e.to_i}
    return associated_well_enos.all?{|e| enos.include?(e)}
  else
    return false
  end
end


def names_hash(names)
  return names.group_by {|n| parse_string(n) }
end

def parse_string(s)
  case s
  when /BMR/
    s=s.gsub(/BMR /,"")
  when /Mt/
    s=s.gsub(/Mt/,"Mount")
  when /no\. ?/i
    s=s.gsub(/no\. ?/i,"")
  when /[\W_]+/
    s=s.gsub(/[\W_]+/," ")
  when /O(?=[0-9])/
    s=s.gsub(/O(?=[0-9])/,"0")
  when /(?<=[A-Z])+0+/
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