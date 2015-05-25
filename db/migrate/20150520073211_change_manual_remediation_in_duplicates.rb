class ChangeManualRemediationInDuplicates < ActiveRecord::Migration
  def change
    change_column :duplicates, :manual_remediation, :string, default:"N" 
  end
end
