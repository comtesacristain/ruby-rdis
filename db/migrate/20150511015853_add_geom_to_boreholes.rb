class AddGeomToBoreholes < ActiveRecord::Migration
  def change
    add_column :boreholes, :geom, :string
  end
end
