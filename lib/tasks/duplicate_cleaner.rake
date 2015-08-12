namespace :duplicate_cleaner do
  
  
  task delete_duplicates: :environment do
    @log = ActiveSupport::Logger.new('log/deleter.log')
    delete_duplicates
  end
  
  task preemptive_backup: :environment do
    @log = ActiveSupport::Logger.new('log/backup.log')
    preemptive_backup
  end
end

def delete_duplicates
  puts "Deleting all duplicates"
  
  duplicates = Duplicate.where(determination:"DELETE").all
  duplicates.transaction do
    duplicates.each do |duplicate|
      delete_duplicate(duplicate)
    end
  end
end
   
def delete_duplicate(duplicate) 
  models = Entity.reflections.keys
  @log.info("Resolving duplicate_id #{duplicate.id}")
  kept_borehole = duplicate.boreholes.includes(:handler).find_by(handlers:{manual_remediation:"KEEP"})
  deleted_boreholes = duplicate.boreholes.includes(:handler).where(handlers:{manual_remediation:"DELETE"})    
  deleted_boreholes.each do |deleted_borehole|
    backup_borehole(deleted_borehole)
    begin
      @log.info("Deleting borehole with eno #{deleted_borehole.eno}")
      deleted_borehole.handler.final_status ="DELETED"
      entity = deleted_borehole.entity
      models.each do |model|
        resolve_model(entity.send(model),kept_borehole.eno)
      end
      entity.delete  
    rescue ActiveRecord::RecordNotFound => e
      puts e
    rescue ActiveRecord::StatementInvalid =>e
      @log.info("#{e.message}"
      deleted_borehole.handler.final_status ="REMAINS"
    ensure
      deleted_borehole.handler.save
    end
  end
  begin
    kept_entity = kept_borehole.entity
  rescue =>e
    @log.info("No kept borehole with eno #{kept_borehole.eno}. ERROR: #{e.message}")
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
  @log.info("Resolving instance of #{instance.class} with eno: #{instance.eno}")
  begin
    instance.eno=eno
    changes = instance.changes
    instance.save
    @log.info("Instance of #{instance.class} with eno: #{changes["eno"][0]} has been transferred to #{changes["eno"][1]}")
  rescue ActiveRecord::StatementInvalid => e
    instance.restore_attributes
    @log.info("Something happened - keep #{eno}, delete #{instance.eno}")
    case e.message
    when /ORA-00001: unique constraint/ # Can't copy data, must delete
    @log.info("Can't move data, must delete #{instance.class.table_name} with eno: #{instance.eno}")
    instance.delete
    #when /ORA-01031/
    #  puts "You have insufficient priveleges to update #{instance.class.table_name}"
    else
    @log.info("Some other Oracle exception: #{e.message}")
    raise ActiveRecord::Rollback
    end
    #rescue => e
    #puts "Some other exception: #{e.message}"
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
    @log.info("Backing up entity: #{borehole.eno}")
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
        @log.info("Nil object found for #{model}")
      else 
        @log.info("Unknown error for #{model}")
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
  @log.info("Backing up instance of #{class_name} with eno #{instance.eno}")
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
