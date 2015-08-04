require "rails/generators"
namespace :backup_manager do
  desc "TODO"
  task create_migrations: :environment do
    create_migrations
  end
end

def create_migrations
  models = Entity.reflections.keys.map{|k| k.singularize}
  models.each do |model|
    model_class = model.to_s.classify.constantize
    attribute_hash = Hash[model_class.columns_hash.map do |k,v|
      if k == "attribute"
        ["a_attribute",v.type]
      else 
        [k,v.type]
      end
    end ]
    attributes = attribute_hash.map{|k,v| "#{k}:#{v}"}
    backup_string = "Borehole#{model.to_s.classify}"
    
   
    begin 
      backup_class = backup_string.constantize
       migration_string = "AddColumnsTo#{backup_string}"
      Rails::Generators.invoke("active_record:migration", [migration_string, attributes].flatten)
    rescue NameError => x
      creation_string = "Create#{backup_string}"
       Rails::Generators.invoke("active_record:model", [backup_string, attributes].flatten)
       Rails::Generators.invoke("active_record:migration", [creation_string, attributes].flatten)
    end
  end
end
