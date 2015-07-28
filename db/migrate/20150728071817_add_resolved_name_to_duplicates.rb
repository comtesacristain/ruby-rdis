class AddResolvedNameToDuplicates < ActiveRecord::Migration
  def change
   add_column :duplicates, :resolved_name, :string
  end
end
