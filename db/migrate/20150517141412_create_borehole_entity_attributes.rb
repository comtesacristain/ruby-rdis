class CreateBoreholeEntityAttributes < ActiveRecord::Migration
  def change
    create_table :borehole_entity_attributes do |t|

      t.timestamps null: false
    end
  end
end
