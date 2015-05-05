namespace :duplicate_manager do
  desc "TODO"
  task find_duplicates: :environment do
    find_duplicates
  end

  desc "TODO"
  task rank_duplicates: :environment do
    rank_duplicates
  end

end

def spatial_queries 
  exact = "select eno, entityid, geom, entity_type from a.entities e where sdo_equal(e.geom,%{geom})='TRUE' and entity_type in ('DRILLHOLE','WELL') "
  hundred_metres = "select eno, entityid, geom, entity_type from a.entities e where sdo_within_distance(e.geom,%{geom},'distance= 100,units=m')='TRUE' and entity_type in ('DRILLHOLE','WELL') "
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
  duplicate_groups = DuplicateGroup.includes(:duplicates).where(duplicates:{eno:enos},kind:kind) #
  if duplicate_groups.exists?
    duplicate_group=duplicate_groups.first
  else
    duplicate_group = DuplicateGroup.create(kind:kind)
    duplicate_group.save
    duplicates.each do | d |
      duplicate_set = duplicate_group.duplicates.where(eno:d["ENO"])
      if duplicate_set.exists?
        duplicate = duplicate_set.first
      else
        geometry=d["GEOM"].instance_variable_get("@attributes")
        duplicate=Duplicate.create(eno:d["ENO"],entityid:d["ENTITYID"],entity_type:d["ENTITY_TYPE"],x:geometry[:sdo_point].instance_variable_get("@attributes")[:x],y:geometry[:sdo_point].instance_variable_get("@attributes")[:y],z:geometry[:sdo_point].instance_variable_get("@attributes")[:z],duplicate_group:duplicate_group)
        duplicate.save
      end
    end
    duplicate_group.save
  end
end

def rank_duplicates
  duplicate_groups=DuplicateGroup.all
  duplicate_groups.each do |duplicate_group|
    duplicates = duplicate_group.duplicates
    type_set=duplicates.pluck(:entity_type)
    if type_set.size == 2
      rank_well_and_drillhole(duplicates)
    elsif type_set.first =="WELL"
      rank_wells(duplicates)
    elsif type_set.first =="DRILLHOLE"
      rank_drillholes(duplicates)
    end
  end
end

def rank_well_and_drillhole(duplicates)
  well_set = duplicates.where(:entity_type=>"WELL")
  drillhole_set = duplicates.where(:entity_type=>"DRILLHOLE")
  if well_set.size == 1
    well=well_set.first
    well.action_status='KEEP'
  else
    rank_wells(well_set)
	return
  end
  drillhole_names = drillhole_set.pluck(:entityid)
  if parse_string(well.entityid).in?(drillhole_names.map{|d| parse_string(d)} )
    drillhole_set.where('entityid like :name',:name=>regex_string(well.entityid)).update_all(:action_status=>'DELETE',:data_transferred_to=>well.eno)
  else
    return
  end
  well.save
end

def rank_wells(duplicates)
  return
end
def rank_drillholes(duplicates)
  names = name_hash(duplicates.pluck(:entityid))
  if names.size > 1
    names.each do |k,v|
      if v.size > 1
        rank_drillholes(duplicates.where(:entityid=>v))
      end
    end 
  elsif names.size ==1 
    dates = Hash[duplicates.map {|d| [d.eno, d.entity.entrydate]}]
    eno = dates.key(dates.values.min)
    duplicates.where(:eno=>eno).update_all(:action_status=>'KEEP')
    duplicates.where(Duplicate.arel_table[:eno].not_in eno).update_all(:action_status=>'DELETE',:data_transferred_to=>eno)
  end
end

def names_hash(names)
  h=names.group_by {|n| strip_leading_zeros(n) }
end

def strip_leading_zeros(s):
    return s.gsub('(?<=[A-Z])+0+','')

def parse_string(s)
    return s.downcase.gsub(/[\W_]+/,' ')
end

def regex_string(s)
    return s.gsub('[\W_]+','%')
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