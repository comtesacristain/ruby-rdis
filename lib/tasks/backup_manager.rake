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
      elsif k =="type"
        ["t_type",v.type]
      else 
        [k,v.type]
      end
    end ]
  
    backup_string = "Borehole#{model.to_s.classify}"
    
   
    begin 
      backup_class = backup_string.constantize
      backup_columns = backup_class.column_names
      backup_columns.each { |c| attribute_hash.delete(c)  }
      migration_string = "AddColumnsTo#{backup_string}"
      unless attribute_hash.empty?
        attributes = attribute_hash.map{|k,v| "#{k}:#{v}"}
        Rails::Generators.invoke("active_record:migration", [migration_string, attributes].flatten)
      end
    rescue NameError => x
      creation_string = "Create#{backup_string}"
      attributes = attribute_hash.map{|k,v| "#{k}:#{v}"}
       Rails::Generators.invoke("active_record:model", [backup_string].flatten)
       Rails::Generators.invoke("active_record:migration", [creation_string, attributes].flatten)
    end
    
  end
end
