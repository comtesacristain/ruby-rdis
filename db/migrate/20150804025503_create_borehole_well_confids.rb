class CreateBoreholeWellConfids < ActiveRecord::Migration
  def change
    create_table :borehole_well_confids do |t|

      t.timestamps null: false
    end
  end
end
