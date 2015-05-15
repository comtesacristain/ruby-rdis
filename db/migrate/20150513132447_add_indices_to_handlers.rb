class AddIndicesToHandlers < ActiveRecord::Migration
  def change
    add_index :handlers, :auto_remediation
    add_index :handlers, :or_status
    add_index :handlers, :or_transfer
    add_index :handlers, [:borehole_id,:or_status]
    
    
    
  end
end
