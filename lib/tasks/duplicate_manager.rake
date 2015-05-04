namespace :duplicate_manager do
  desc "TODO"
  task find_duplicates: :environment do
    #find_duplicates
  end

  desc "TODO"
  task rank_duplicates: :environment do
    
  end

end

#def find_duplicates
#  puts "Found duplicates"
#  conn=OCI8.new(database.DATABASES['production']['USER'],database.DATABASES['production']['PASSWORD'],database.DATABASES['production']['NAME'])

#  conn.exec("alter session set nls_date_format='DD-MON-YYYY'")
#  entities=conn.exec("select eno, entityid, geom, entity_type from a.entities where entity_type in ('DRILLHOLE', 'WELL') and geom is not null")


  
#end