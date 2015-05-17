class CreateBoreholeWells < ActiveRecord::Migration
  def change
    create_table :borehole_wells do |t|

      t.timestamps null: false
    end
  end
end
