namespace :duplicate_manager do
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

end

def query_terms
  return "eno, entityid, entity_type, geom, access_code,confid_until,qa_status_code,qadate,acquisition_methodno,geom_original,parent,remark,eid_qualifier"
end

def spatial_queries 
  exact = "select #{query_terms} from a.entities e where sdo_equal(e.geom,%{geom})='TRUE' and entity_type in ('DRILLHOLE','WELL') "
  hundred_metres = "select #{query_terms} from a.entities e where sdo_within_distance(e.geom,%{geom},'distance= 100,units=m')='TRUE' and entity_type in ('DRILLHOLE','WELL') "
  return {:exact=>exact,:hundred_metres=>hundred_metres}
end

def find_duplicates
  db=YAML.load_file('config/database.yml')
  connection=OCI8.new(db["production"]["username"],db["production"]["password"],db["production"]["database"])
  cursor=connection.exec("select eno, entityid, geom, entity_type from a.entities where entity_type in ('DRILLHOLE', 'WELL') and geom is not null") 
  cursor.fetch_hash do |row|
    spatial_queries.each_key do |k|
      geom = to_sdo_string(row["GEOM"])
      statement=spatial_queries[k] % {:geom=>geom,:eno=>row["ENO"]}
      results=connection.exec(statement)
      duplicates = Array.new
      results.fetch_hash{ |r| duplicates.push(r)}
      if duplicates.count > 1
        insert_duplicates(duplicates,k)
      end
    end
  end
end

def insert_duplicates(duplicates,kind) #kind 
  enos = duplicates.map{|d| d["ENO"]}
  duplicate_groups = Duplicate.includes(:boreholes).where(boreholes:{eno:enos},kind:kind) #
  if duplicate_groups.exists?
    duplicate_group=duplicate_groups.first
  else
    duplicate_group = Duplicate.create(kind:kind)
    duplicate_group.save
  end
  duplicates.each do | d |
      boreholes = Borehole.where(eno:d["ENO"])
      if boreholes.exists?
        borehole = boreholes.first
      else
        geometry=d["GEOM"].instance_variable_get("@attributes")
        #TODO Add format row for insert routine
        borehole=Borehole.create(eno:d["ENO"],entityid:d["ENTITYID"],entity_type:d["ENTITY_TYPE"],x:geometry[:sdo_point].instance_variable_get("@attributes")[:x],y:geometry[:sdo_point].instance_variable_get("@attributes")[:y],z:geometry[:sdo_point].instance_variable_get("@attributes")[:z],access_code:d["ACCESS_CODE"],confid_until:d["CONFID_UNTIL"],qa_status_code:d["QA_STATUS_CODE"],qadate:d["QADATE"],acquisition_methodno:d["ACQUISITION_METHODNO"],geom_original:to_sdo_string(d["GEOM_ORIGINAL"]),parent:d["PARENT"],remark:d["remark"],eid_qualifier:row["EID_QUALIFIER"])
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
    db=YAML.load_file('config/database.yml')
  connection=OCI8.new(db["production"]["username"],db["production"]["password"],db["production"]["database"])
  boreholes = Borehole.all
  boreholes.each do |borehole|
    statement = "select #{query_terms} from a.entities e where eno =#{borehole.eno}"
    cursor=connection.exec(statement)
    row = cursor.fetch_hash
    geometry = row["GEOM"].instance_variable_get("@attributes")
    borehole.update(eno:row["ENO"],entityid:row["ENTITYID"],entity_type:row["ENTITY_TYPE"],x:geometry[:sdo_point].instance_variable_get("@attributes")[:x],y:geometry[:sdo_point].instance_variable_get("@attributes")[:y],z:geometry[:sdo_point].instance_variable_get("@attributes")[:z],access_code:row["ACCESS_CODE"],confid_until:row["CONFID_UNTIL"],qa_status_code:row["qa_status_code"],qadate:row["QADATE"],acquisition_methodno:row["ACQUISITION_METHODNO"],geom_original:to_sdo_string(row["GEOM_ORIGINAL"]),parent:row["PARENT"],remark:row["remark"],eid_qualifier:row["EID_QUALIFIER"])
    borehole.save
  end
end

def rank_duplicates
  duplicate_groups=Duplicate.all
  duplicate_groups.each do |duplicate_group|
    boreholes = duplicate_group.boreholes
    type_set=boreholes.pluck(:entity_type)
    if type_set.size == 2
      rank_well_and_drillhole(boreholes)
    elsif type_set.first =="WELL"
      rank_wells(boreholes)
    elsif type_set.first =="DRILLHOLE"
      rank_drillholes(boreholes)
    end
    actions = duplicate_group.boreholes.pluck(:action)
      if "DELETE".in?(actions)
                duplicate_group.has_resolution = 'Y'
                duplicate_group.save
              end
  end
end

def rank_well_and_drillhole(boreholes)
  well_set = boreholes.where(:entity_type=>"WELL")
  drillhole_set = boreholes.where(:entity_type=>"DRILLHOLE")
  if well_set.size == 1
    well=well_set.first
    well.action='KEEP'
  else
    rank_wells(well_set)
	return
  end
  drillhole_names = drillhole_set.pluck(:entityid)
  if parse_string(well.entityid).in?(drillhole_names.map{|d| parse_string(d)} )
    drillhole_set.where('entityid like :name',:name=>regex_string(well.entityid)).update_all(:action=>'DELETE',:data_transferred_to=>well.eno)
  else
    return
  end
  well.save
end

def rank_wells(boreholes)
  return
end

def rank_drillholes(boreholes)
  names = names_hash(boreholes.pluck(:entityid))
  if names.size > 1
    names.each do |k,v|
      if v.size > 1
        rank_drillholes(boreholes.where(:entityid=>v))
      end
    end 
  elsif names.size ==1 
    dates = Hash[boreholes.map {|d| [d.eno, d.entity.entrydate]}]
    eno = dates.key(dates.values.min)
    puts boreholes.pluck(:entityid)
    keep=boreholes.where(:eno=>eno).update_all(:action=>'KEEP')
    print keep
    delete=boreholes.where(Borehole.arel_table[:eno].not_in eno).update_all(:action=>'DELETE',:data_transferred_to=>eno)
    print delete
    boreholes.each {|b| b.save}
  end
end

def names_hash(names)
  return names.group_by {|n| strip_leading_zeros(n) }
end

def strip_leading_zeros(s)
    return s.gsub(/(?<=[A-Z])+0+/,'')
end
  
def parse_string(s)
    return s.downcase.gsub(/[\W_]+/,' ')
end

def regex_string(s)
    return s.gsub(/[\W_]+/,'%')
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