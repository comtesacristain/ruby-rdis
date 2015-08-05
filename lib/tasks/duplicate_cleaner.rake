namespace :duplicate_cleaner do
  task delete_duplicates: :environment do
    delete_duplicates
  end
  

end




def delete_duplicates
  puts "Deleting duplicates"
  models = Entity.reflections.keys
  duplicates = Duplicate.limit(50)
  duplicates.transaction do
    duplicates.each do |duplicate|
   
      kept_borehole = duplicate.boreholes.includes(:handler).find_by(handlers:{manual_remediation:"KEEP"})
      deleted_boreholes = duplicate.boreholes.includes(:handler).where(handlers:{manual_remediation:"DELETE"})
      # deleted_borehole = deleted_boreholes.first
      deleted_boreholes.each do |deleted_borehole|
        
        backup_borehole(deleted_borehole)
        
        begin
          puts "Deleting borehole with eno #{deleted_borehole.eno}"
          entity = deleted_borehole.entity
          
          
          models.each do |model|
            resolve_model(entity.send(model),kept_borehole.eno)
          end
          entity.delete unless entity.nil?
        rescue ActiveRecord::RecordNotFound => e
          puts e
        ensure
          deleted_borehole.handler.final_status ="DELETED"
        end
      end
      duplicate.resolved = "Y"
     
    end
     raise ActiveRecord::Rollback
  end
end

def resolve_model(delete,keep_eno)
  case 
  when delete.is_a?(ActiveRecord::Base)
    delete.delete
  when delete.is_a?(ActiveRecord::Associations::CollectionProxy)
    delete.each do |d|
      begin
        d.eno = keep_eno
        d.save
      rescue
        d.delete
      end
    end
  when delete.is_a?(NilClass)
  end
end



def backup_borehole(borehole)
  models = Entity.reflections.keys
  begin
    entity = borehole.entity 
    puts "Backing up entity: #{borehole.eno}"
    # entity = Borehole.first.entity
    models.each do |model|
      model_instance = entity.send(model)
      case 
      when model_instance.is_a?(ActiveRecord::Base)
        backup_instance(model_instance)
      when model_instance.is_a?(ActiveRecord::Associations::CollectionProxy)
        model_instance.each do |mi|
          backup_instance(mi)
        end
      when model_instance.is_a?(NilClass)
        "Nil object found"
      else 
        "Blabla"
      end
    end
  rescue ActiveRecord::RecordNotFound => ex
    puts ex
  end
end


def backup_instance(instance)
  class_name = instance.class.to_s
  backup_class_name = "Borehole#{class_name}"
  backup_class = backup_class_name.constantize
  attributes=remove_dodgy_attributes(instance.attributes)
  object = backup_class.find_or_initialize_by(attributes)
  object.save
end

def remove_dodgy_attributes(attributes)
  if attributes["attribute"]
    attributes["a_attribute"] = attributes.delete "attribute"
  elsif attributes["type"]
      attributes["t_type"] = attributes.delete "type"
  end
  return attributes
end
