namespace :duplicate_cleaner do
  
  
  task delete_duplicates: :environment do
    @log = ActiveSupport::Logger.new('log/deleter.log')
    delete_duplicates
  end
  
   task delete_unresolved_duplicates: :environment do
    @log = ActiveSupport::Logger.new('log/delete_unresolved.log')
    delete_unresolved_duplicates
  end
  
  task preemptive_backup: :environment do
    @log = ActiveSupport::Logger.new('log/backup.log')
    preemptive_backup
  end
end

def delete_duplicates
  @log.info("\n[INFO] Deleting all duplicates")
  
  duplicates = Duplicate.where(determination:"DELETE").all
  duplicates.transaction do
    duplicates.each do |duplicate|
      delete_duplicate(duplicate)
    end
  end
end

def delete_unresolved_duplicates
  @log.info("\n[INFO] Deleting all unresolved duplicates")
  
  duplicates = Duplicate.where(determination:"DELETE",resolved:"N").all
  duplicates.transaction do
    duplicates.each do |duplicate|
      delete_duplicate(duplicate)
    end
  end
end
   
def delete_duplicate(duplicate) 
  models = Entity.reflections.keys
  @log.info("[INFO] esolving duplicate #{duplicate.id}")
  kept_borehole = duplicate.boreholes.includes(:handler).find_by(handlers:{manual_remediation:"KEEP"})
  if kept_borehole.nil?
    @log.info("[WARN] No kept borehole for duplicate #{duplicate.id}. Not proceeding")
    return  
  end
  deleted_boreholes = duplicate.boreholes.includes(:handler).where(handlers:{manual_remediation:"DELETE"})    
  deleted_boreholes.each do |deleted_borehole|
    backup_borehole(deleted_borehole)
    begin
      @log.info("[INFO] Deleting borehole with eno #{deleted_borehole.eno}")
      
      entity = deleted_borehole.entity
      models.each do |model|
        resolve_model(entity.send(model),kept_borehole.eno)
      end
      begin
        entity.delete  
        deleted_borehole.handler.final_status ="DELETED"
      rescue ActiveRecord::StatementInvalid =>e
        @log.info("[ERROR] Can't delete borehole with eno #{deleted_borehole.eno}. MESSAGE: #{e.message}")
        deleted_borehole.handler.final_status ="REMAINS"
      end
    rescue ActiveRecord::RecordNotFound => e
      @log.info("[ERROR] Can't find borehole with eno #{deleted_borehole.eno}. MESSAGE: #{e.message}")
      deleted_borehole.handler.final_status ="DELETED"
    ensure
      deleted_borehole.handler.save
    end
  end
  begin
    kept_entity = kept_borehole.entity
    kept_entity.entityid = duplicate.resolved_name.nil? ?  kept_entity.entityid : duplicate.resolved_name
    kept_entity.save
  rescue => e
    @log.info("[ERROR] No kept borehole with eno #{kept_borehole.eno}. MESSAGE: #{e.message}")
  end
  if deleted_boreholes.where(handlers:{final_status:"REMAINS"}).exists?
    duplicate.resolved="N"
  else
    duplicate.resolved="Y"
  end
  duplicate.save
end


def resolve_model(delete,eno)
  case 
  when delete.is_a?(ActiveRecord::Base)
   resolve_instance(delete,eno)
  when delete.is_a?(ActiveRecord::Associations::CollectionProxy)
    delete.each do |d|
      resolve_instance(d,eno)
    end
  when delete.is_a?(NilClass)
  end
end

def resolve_instance(instance,eno)
  resolved_eno=instance.eno
  @log.info("[INFO] Resolving instance of #{instance.class} with primary key #{instance.id} belonging to borehole with eno: #{instance.eno}")
  begin
    instance.eno=eno
    changes = instance.changes
    instance.save
    @log.info("[INFO] Instance of #{instance.class} with primary key #{instance.id} belonging to borehole with eno: #{resolved_eno} has been transferred to #{eno}")
  rescue ActiveRecord::StatementInvalid => e
    instance.eno=resolved_eno
    @log.info("[ERROR] Error occurred in trying to update #{instance.class} with primary key #{instance.id} belonging to borehole with eno: #{resolved_eno}. Could not transfer to #{eno}")
    case e.message
    when /ORA-00001: unique constraint/ # Can't copy data, must delete
	  @log.info("[ERROR] Can't move data, must delete #{instance.class.table_name} with primary key #{instance.id} belonging to borehole with eno: #{resolved_eno}. MESSAGE: #{e.message}")
      instance.delete
    when /ORA-01031/
      @log.info("[ERROR] You have insufficient priveleges to update #{instance.class.table_name}. MESSAGE: #{e.message}")
    else
		@log.info("[ERROR] Some other Oracle exception. MESSAGE: #{e.message}")
    end
  rescue => e
    @log.info("[ERROR] Cannot resolve #{instance.class} with eno: #{resolved_eno}, unknown error. MESSAGE: #{e.message}")
  end
end

def preemptive_backup
  duplicates=Duplicate.all
  duplicates.each do |duplicate|
    deleted_boreholes = duplicate.boreholes.includes(:handler).where(handlers:{manual_remediation:"DELETE"})
    deleted_boreholes.each do |deleted_borehole|
      backup_borehole(deleted_borehole)
    end
  end
end


def backup_borehole(borehole)
  models = Entity.reflections.keys
  begin
    entity = borehole.entity 
    @log.info("[INFO] Backing up borehole entity: #{borehole.eno}")
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
        @log.info("[WARN] No record found for #{model.classify}")
      else 
        @log.info("[ERROR] Unknown error for #{model.classify}")
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    @log.info("Cannot back up borehole with eno #{borehole.eno}. MESSAGE: #{e.message}")
  end
end


def backup_instance(instance)
  class_name = instance.class.to_s
  backup_class_name = "Borehole#{class_name}"
  backup_class = backup_class_name.constantize
  attributes=remove_dodgy_attributes(instance.attributes)
  @log.info("[INFO] Backing up instance of #{class_name} with primary key #{instance.id} belonging to borehole with eno #{instance.eno}")
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
