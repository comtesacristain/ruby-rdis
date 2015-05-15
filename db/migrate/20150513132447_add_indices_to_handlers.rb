class AddIndicesToHandlers < ActiveRecord::Migration
  def change
    add_index :handlers, :auto_remedation
    add_index :handlers, :or_status
    add_index :handlers, :or_transfer
    add_index :handlers, [:borehole_id,:or_status]
    add_index :boreholes, :eno
    add_index :boreholes, :entity_type
    add_index :boreholes, :entityid
    
    
  end
end
