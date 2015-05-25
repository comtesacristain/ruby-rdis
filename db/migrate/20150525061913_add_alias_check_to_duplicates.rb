class AddAliasCheckToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :alias_check, :string
  end
end
