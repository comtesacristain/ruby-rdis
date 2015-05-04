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
    puts row
  end
end