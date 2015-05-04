require 'oci8'
namespace :duplicate_manager do
  desc "TODO"
  task find_duplicates: :environment do
    find_duplicates
  end

  desc "TODO"
  task rank_duplicates: :environment do
    
  end

end

def exact 
  return "select eno, entityid, geom, entity_type from a.entities e where sdo_equal(e.geom,%{geom})='TRUE' and entity_type in ('DRILLHOLE','WELL')"
end

def find_duplicates
  db=YAML.load_file('config/oracle.yml')
  connection=OCI8.new(db["production"]["username"],db["production"]["password"],db["production"]["database"])
  cursor=connection.exec("select eno, entityid, geom, entity_type from a.entities where entity_type in ('DRILLHOLE', 'WELL') and geom is not null and rownum <20") 
  cursor.fetch_hash do |row|
    geom = to_sdo_string(row["GEOM"])
    statement=exact % {:geom=>geom,:eno=>row["ENO"]}
    results=connection.exec(statement)
    duplicates = Array.new()
    results.fetch_hash{ |r| duplicates.push(r)}
    insert_duplicates(duplicates)

  end
end

def insert_duplicates(duplicates) #kind 
  enos = duplicates.map{|d| d["ENO"]}
  duplicate_groups = DuplicateGroup.includes(:duplicates).where(duplicates:{eno:enos}) #kind:kind
  if duplicate_groups.exists?
    duplicate_group=duplicate_groups.first
  else
    duplicate_group = DuplicateGroup.new
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