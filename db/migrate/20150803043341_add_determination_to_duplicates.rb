class AddDeterminationToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :determination, :string
  end
end
