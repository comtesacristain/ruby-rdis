namespace :duplicate_cleaner do
  task delete_duplicates: :environment do
    delete_duplicates
  end
  

end


def delete_duplicates
  puts "Deleting duplicates"
  duplicates = Duplicate.limit(50)
  duplicates.transaction do
    duplicates.each do |duplicate|
   
      kept_borehole = duplicate.boreholes.includes(:handler).find_by(handlers:{manual_remediation:"KEEP"})
      deleted_boreholes = duplicate.boreholes.includes(:handler).where(handlers:{manual_remediation:"DELETE"})
      # deleted_borehole = deleted_boreholes.first
      deleted_boreholes.each do |deleted_borehole|
        puts deleted_borehole.eno
        begin
          entity = deleted_borehole.entity
          
          backup_borehole(deleted_borehole)
          
          
          entity.stratigraphies.update_all(eno:kept_borehole.eno)
        
          entity.samples.update_all(eno:kept_borehole.eno)
          fix_constrained_model(entity.remarkws,kept_borehole.eno)
          fix_constrained_model(entity.resultws,kept_borehole.eno)
          fix_constrained_model(entity.resfacs_remarks,kept_borehole.eno)
          fix_constrained_model(entity.entity_attributes,kept_borehole.eno)
          fix_constrained_model(entity.porperm_twos,kept_borehole.eno)
          fix_constrained_model(entity.porperm_picks,kept_borehole.eno)
          entity.porperm_one.delete unless entity.porperm_one.nil?
          entity.sidetrack.delete unless entity.sidetrack.nil?
          entity.well.delete unless entity.well.nil?
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

def fix_constrained_model(delete,keep_eno)
  delete.each do |d|
    begin
      d.eno = keep_eno
      d.save
    rescue
      d.delete
    end
  end
end



def backup_borehole(borehole)
  duplicates = Duplicate.all
  models = Entity.reflections.keys
  duplicates.each do |duplicate|
    boreholes = duplicate.boreholes.includes(:handler).where(handlers:{manual_remediation:"DELETE"})
    boreholes.each do |borehole|
      begin
        entity = borehole.entity 
        puts borehole.eno
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
