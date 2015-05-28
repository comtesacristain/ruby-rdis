class AddKeepToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :keep, :integer
  end
end
