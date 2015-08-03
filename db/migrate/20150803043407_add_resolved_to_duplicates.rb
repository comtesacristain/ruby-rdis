class AddResolvedToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :resolved, :string
  end
end
