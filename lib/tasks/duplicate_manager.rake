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
  
  desc "TODO"
  task load_manual_backup: :environment do
    load_manual_backup
  end

end

def run_all
  load_boreholes
  if Handler.where.not(:or_status=>'undetermined').empty?
    load_spreadsheet
  end
  find_and_rank
  load_wells
end

def find_and_rank
  or_duplicates
  distance_queries.each do |d|
     rank_duplicates
     find_duplicates(d)
  end
end

def load_boreholes(n=nil)
  connection=OCI8.new(db["oracle_production"]["username"],db["oracle_production"]["password"],db["oracle_production"]["database"])
  statement = "select #{borehole_query_string} from a.entities e where entity_type in ('DRILLHOLE', 'WELL')"
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
      if orc =~ /[0-9]{4,6}/
        or_transfer = orc.match(/[0-9]{4,6}/)[0]
      end
      unless or_transfer.nil?
        handler.or_transfer = or_transfer
      end
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

def load_manual_backup
  spreadsheet = 'backup.xlsx'
  wb =Roo::Spreadsheet.open(spreadsheet)
  sheet = wb.sheet(0)
  manual_duplicates = Hash.new
  ((sheet.first_row + 1)..sheet.last_row).each do |row|
    manual_duplicates[sheet.row(row)[0].to_i] ||= []
    manual=Hash.new
    manual[:eno] = sheet.row(row)[2].to_i
    manual[:remediation] = sheet.row(row)[23]
    manual[:transfer] = sheet.row(row)[24].to_i
    manual[:comments] = sheet.row(row)[25]
    manual_duplicates[sheet.row(row)[0].to_i].push(manual)
  end
  manual_duplicates.each do |k,a|
    enos = a.map{|h| h[:eno]}
    
    duplicate = Duplicate.includes(:boreholes).find_by(boreholes:{eno:enos})
    duplicate.manual_remediation = "Y"
    auto_approved = "Y"
    a.each do |item|
      borehole = duplicate.boreholes.find_by(eno:item[:eno])
      borehole.handler.manual_remediation = item[:remediation]
      borehole.handler.manual_transfer = (item[:transfer] == 0 ? nil : item[:transfer] )
      if borehole.handler.manual_remediation != borehole.handler.auto_remediation 
        auto_approved = "N"
      end
      duplicate.comments = item[:comments]
      borehole.handler.save
    end
    duplicate.auto_approved = auto_approved
    duplicate.save
  end 
end

def or_duplicates
   boreholes=Borehole.joins(:handler).where.not(handlers:{or_transfer:nil})
   boreholes.each do |borehole|
     transfer_borehole = Borehole.find_by(eno:borehole.handler.or_transfer)
     unless transfer_borehole.nil?
       enos = [transfer_borehole.eno,borehole.eno]
       duplicate = find_or_create_duplicate_by_boreholes(enos,"or")
       duplicate.boreholes=[borehole,transfer_borehole]
       duplicate.save
     end
   end
end

def find_duplicates(d=0)
  
  connection=OCI8.new(db["oracle_production"]["username"],db["oracle_production"]["password"],db["oracle_production"]["database"])
  boreholes=Borehole.joins(:handler).where(Handler.arel_table[:or_status].not_eq("no").and(Handler.arel_table[:auto_remediation].eq('NONE')))
  boreholes.each do |borehole|
    
    geom = borehole.geom
    name = borehole.entityid
    if geom == "NULL"
      puts "Searching for duplicates for borehole #{borehole.eno} with name #{name}"
      statement = name_query(name)
      kind="name"
    else
      puts "Searching for duplicates around borehole #{borehole.eno} within #{d} metres"   
      statement=spatial_query(geom,d)
      kind = "#{d}m"
    end
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

def group_by_name(duplicates)
  duplicate_attr = "ENTITYID"
  names=duplicates.map{|d| d[duplicate_attr]}
  sampleno_names=names.select{|n| n.match(/\A[0-9]{14}\z/) } # Check if array of ENTITYIDs contains 14 character strings completely composed of numbers
  unless sampleno_names.empty?
    if (names-sampleno_names).empty?
      puts "Grouping by EID_QUALIFIER ..."
      duplicate_attr = "EID_QUALIFIER"
      names=duplicates.map{|d|  d[duplicate_attr]}
    else
      names=names-sampleno_names
    end
  end
  puts "Grouping names: #{names.join(',')}"
  nh = names_hash(names)
  grouped_names = nh.values.select{|v| v.size > 1}
  named_duplicates =Array.new
  grouped_names.each do |n|
    named_duplicates.push(duplicates.select{|hash| n.include?(hash[duplicate_attr])})
  end
  return named_duplicates
end
  
  
def find_or_create_duplicate_by_boreholes(enos,kind)
  duplicates = Duplicate.includes(:boreholes).where(boreholes:{eno:enos}) #,kind:kind
  if duplicates.exists?
    duplicate=duplicates.first
  else
    duplicate = Duplicate.new(:auto_remediation=>'N',:kind=>kind)
  end
  return duplicate
end

def insert_duplicates(duplicates,kind='100m')
  enos = duplicates.map{|d| d["ENO"]}
  puts "Inserting boreholes into database with enos #{enos.join(',')}"
  duplicate_group = find_or_create_duplicate_by_boreholes(enos,kind)
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


def rank_duplicates
  duplicate_groups=Duplicate.all
  duplicate_groups.each do |duplicate_group|
    boreholes = duplicate_group.boreholes
      #name_sort(boreholes)
      rank_set(boreholes)
      auto_remediations = duplicate_group.boreholes.includes(:handler).pluck(:auto_remediation)
      if "DELETE".in?(auto_remediations)
        duplicate_group.update(:auto_remediation=>'Y')
      else
        duplicate_group.update(:auto_remediation=>'N')
      end
  end

end


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
    holes = has_holes(boreholes)
    if holes.size == 1
      eno = holes.first
      keep = boreholes.find_by(eno:eno)
      delete = boreholes.where.not(eno:eno)
      delete.each {|b|  b.handler.update({:auto_remediation=>"DELETE",:auto_transfer=>eno})}
      keep.handler.update(:auto_remediation=>'KEEP')
      return keep
    else
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
          keep=boreholes.find_by(:eno=>eno)
          keep.handler.update(:auto_remediation=>'KEEP')
          return keep
        end
      end
    end
  else
    boreholes.first.handler.auto_remediation="NONE"
    boreholes.first.handler.save
    return nil
  end
end

def has_holes(boreholes)
  enos = boreholes.map do |borehole|
    if ! borehole.entity.well.nil?
      borehole.entity.well.well_confids.empty? ?  nil : borehole.eno 
    end
  end
  return enos.compact
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



def names_hash(names)
  return names.group_by {|n| parse_string(n) }
end

def parse_string(s)
  ##
  
  ##
  if s.nil?
    return nil
  end
  if s =~ /((JUG[0-9]{1,2}A)|(HARD [0-9]{1,2}\/[0-9]{1,2}Y)|(CW[0-9]{1,2}))/
    s=s.match(/((JUG[0-9]{1,2}A)|(HARD [0-9]{1,2}\/[0-9]{1,2})|(CW[0-9]{1,2}))/)[0]
  end
  if s =~ /Ginninderra [0-9]{1,2}/
    s=s.match(/Ginninderra [0-9]{1,2}/)[0]
  end
  if s =~ /(?<=[0-9]{4})(H|RP)(?=[0-9]{3})/
    s=s.gsub(/(?<=[0-9]{4})(H|RP)(?=[0-9]{3})/,"")
  end
  if s =~ /(?<=BH)D(?=[0-9]{3})/
    s = s.gsub(/(?<=BH)D(?=[0-9]{3})/,"O")
  end
  if s =~ /REVC0/
    s=s.gsub(/REVC0/,"2446-")
  end
  if s =~ /^REVCH[0-9]{4}\/[0-9]/
    s=s.gsub(/^REVCH[0-9]{4}\/[0-9]/,"2252")
  end
  if s =~ /BMR/
    s=s.gsub(/BMR /,"")
  end
  if s =~ /Mt/
    s=s.gsub(/Mt/,"Mount")
  end
  if s =~ /( rock| soil)/i
    s=s.gsub(/( rock| soil)/i,"")
  end
  if s =~ /( 0\.25| surface)/i
    s=s.gsub(/( 0\.25| surface)/i,"")
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
  return attr_hash(row,:borehole)
end

def sample_attr_hash(row)
  return attr_hash(row,:sample)
end

def well_attr_hash(row)
  return attr_hash(row,:well)
end

def attr_hash(row, type)
  h = Hash.new
  query_terms(type).each do |qt|
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
    elsif qt ==:attribute
      attribute_hash = {attr:row[qt.to_s.upcase]}
      h.merge!(attribute_hash)
    else
      h[qt] = row[qt.to_s.upcase]
    end
  end
  return h
end


def db
  return YAML.load_file('config/database.yml')
end


def query_string(type=nil)
  return query_terms(type).join(",")
end

def borehole_query_string
  return query_string(:borehole)
end

def sample_query_string
  return query_string(:sample)
end

def well_query_string
  return query_string(:well)
end

def query_terms(type=nil)
  case type
  when :borehole
    return [:eno, :entityid, :entity_type, :geom, :access_code, :confid_until,:qa_status_code,:qadate,:acquisition_methodno,:geom_original,:parent,:remark,:eid_qualifier]
  when :sample
    return [:sampleno, :eno, :sampleid, :sample_type, :top_depth, :base_depth, :parent, :originator, :acquiredate, :geom_original]
  when :well
    return [:eno, :welltype, :purpose, :on_off, :title, :classification, :status, :ground_elev, :operator, :uno, :start_date, :completion_date, :comments, :total_depth, :originator, :origno]
  else
    return ["*"]
  end
end

def sample_query_terms
  query_terms(:sample)
end

def borehole_query_terms
  query_terms(:borehole)
end

def well_query_terms
  query_terms(:well)
end

def spatial_query(geom,d=100)
  return "select #{borehole_query_string} from a.entities e where sdo_within_distance(e.geom,#{geom},'distance= #{d},units=m')='TRUE' and entity_type in ('DRILLHOLE','WELL')"
end

def name_query(name)

  return "select #{borehole_query_string} from a.entities e where upper(e.entityid) like upper('#{name}') and entity_type in ('DRILLHOLE','WELL')"
end

def load_samples
  connection=OCI8.new(db["oracle_production"]["username"],db["oracle_production"]["password"],db["oracle_production"]["database"])
  duplicates = Duplicate.all
  duplicates.each do |duplicate|
    boreholes = duplicate.boreholes
    boreholes.each do |borehole|
      statement = "select #{sample_query_string} from a.samples s where eno =  #{borehole.eno}"
      cursor=connection.exec(statement)
      cursor.fetch_hash do |row|
        sample = BoreholeSample.find_or_initialize_by(sampleno:row["SAMPLENO"])
        puts "Loading sample #{sample.sampleno}"
        sample.update(sample_attr_hash(row))
        borehole.sample= sample
        borehole.save
      end
    end
  end
end

def load_wells
  connection=OCI8.new(db["oracle_production"]["username"],db["oracle_production"]["password"],db["oracle_production"]["database"])
  duplicates = Duplicate.all
  duplicates.each do |duplicate|
    boreholes = duplicate.boreholes
    boreholes.each do |borehole|
      statement = "select #{well_query_string} from npm.wells w where eno =  #{borehole.eno}"
      cursor=connection.exec(statement)
      cursor.fetch_hash do |row|
        well = BoreholeWell.find_or_initialize_by(eno:row["ENO"])
        puts "Loading well #{well.eno}"
        well.update(well_attr_hash(row))
        borehole.well = well
        borehole.save
      end
    end
  end
end


def entity_remediation
  duplicates = Duplicate.all
  duplicates.each do |duplicate|
    boreholes = duplicate.boreholes
    geom_hash =  Hash[boreholes.pluck(:eno,:x,:y,:z).map{|b| [b[0], b[1..3]]}]
    geom_hash.each do |k,v|
      
    end
  end
end


def well_remediation
  
end
def distance_queries 
  return [0,500,1500,5000,15000]
end
