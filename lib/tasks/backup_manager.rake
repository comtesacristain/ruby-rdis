namespace :backup_manager do
  desc "TODO"
  task create_migrations: :environment do
    create_migrations
  end
end

def create_migrations
  models = [:well,:sample,:remarkw,:entity_attribute,
    :mineral_attribute,:sidetrack,:stratigraphy,:well_confid,
    :resfacs_remark]
  models.each do |model|
    model_class = model.to_s.classify.constantize
    attribute_hash = Hash[model_class.columns_hash.map {|k,v| [k,v.type]}]
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
