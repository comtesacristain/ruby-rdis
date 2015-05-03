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
  puts "Found duplicates"
  conn=OCI8.new(database.DATABASES['production']['USER'],database.DATABASES['production']['PASSWORD'],database.DATABASES['production']['NAME'])
  conn.exec("alter session set nls_date_format='DD-MON-YYYY'")
  entities=conn.exec("select eno, entityid, geom, entity_type from a.entities where entity_type in ('DRILLHOLE', 'WELL') and geom is not null")
  #duplicates = list()
  for entity in entities:
      for key in spatial_queries.keys():
          geom = entity[2]
          if geom is not None:
              search_geometry = self.to_sdo_string(geom)
              stmt = spatial_queries[key].format(eno=entity[0],geom=search_geometry)
              results=curs.execute(stmt).fetchall()
              if results.__len__() > 0:
                  self.insert_dupes(entity, results,key)
  
end