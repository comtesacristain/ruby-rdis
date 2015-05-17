class CreateBoreholeMineralAttributes < ActiveRecord::Migration
  def change
    create_table :borehole_mineral_attributes do |t|

      t.timestamps null: false
    end
  end
end
