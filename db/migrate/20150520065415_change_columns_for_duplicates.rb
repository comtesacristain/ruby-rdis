class ChangeColumnsForDuplicates < ActiveRecord::Migration
  def change
    rename_column :duplicates, :qaed, :manual_remediation
    rename_column :duplicates, :has_remediation, :auto_remediation
    add_column :duplicates, :auto_approved
    
    change_column :duplicates, :manual_remediation, :string, default:"N" 

  end
end
