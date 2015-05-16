class ChangeColumnsInHandlers < ActiveRecord::Migration
  def change
    change_column :handlers, :auto_remediation, :string, default:"NONE"
    change_column :handlers, :or_status, :string, default:"undetermined"
  end
end
