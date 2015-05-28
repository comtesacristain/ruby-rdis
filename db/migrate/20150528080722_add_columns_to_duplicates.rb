class AddColumnsToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :eid_qualifier, :integer
    add_column :duplicates, :remark, :integer
    add_column :duplicates, :access_code, :integer
    add_column :duplicates, :acquisition_methodno, :integer
  end
end
