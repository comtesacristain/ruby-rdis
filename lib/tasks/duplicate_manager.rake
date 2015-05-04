namespace :duplicate_manager do
  desc "TODO"
  task find_duplicates: :environment do
    find_duplicates
  end

  desc "TODO"
  task rank_duplicates: :environment do
    
  end

end

def find_duplicates
  db=YAML.load_file('config/database.yml')
  connection=OCI8.new(db["production"]["username"],db["production"]["password"],db["production"]["database"])
  cursor=connection.exec("select eno, entityid, geom, entity_type from a.entities where entity_type in ('DRILLHOLE', 'WELL') and geom is not null and rownum < 20")
  cursor.fetch_hash do |row|
    geom = to_sdo_string(row["GEOM"])
    print geom
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
    when "OCI8::Object::Mdsys::SdoPointType"
      if geom[:z].nil?
        return "SDO_POINT_TYPE(#{geom[:x]},#{geom[:y]},NULL)"
      else
        return "SDO_POINT_TYPE(#{geom[:x]},#{geom[:y]},#{geom[:z]})"
      end
    end
  end
end