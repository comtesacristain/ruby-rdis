class CreateBoreholeStratigraphies < ActiveRecord::Migration
  def change
    create_table :borehole_stratigraphies do |t|

      t.timestamps null: false
    end
  end
end
