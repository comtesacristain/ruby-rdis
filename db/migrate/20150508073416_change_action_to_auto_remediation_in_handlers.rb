class ChangeActionToAutoRemediationInHandlers < ActiveRecord::Migration
  def change
    rename_column :handlers, :action, :auto_remediation
    rename_column :handlers, :data_transferred_to, :auto_transfer
  end
end
