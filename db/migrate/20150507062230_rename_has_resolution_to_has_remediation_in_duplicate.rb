class RenameHasResolutionToHasRemediationInDuplicate < ActiveRecord::Migration
  def change
    rename_column :duplicates, :has_resolution, :has_remediation
  end
end
