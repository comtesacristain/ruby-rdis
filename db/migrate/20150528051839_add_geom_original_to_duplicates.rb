class AddGeomOriginalToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :geom_original, :integer
  end
end
