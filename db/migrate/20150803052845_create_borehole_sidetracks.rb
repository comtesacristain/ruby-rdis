class CreateBoreholeSidetracks < ActiveRecord::Migration
  def change
    create_table :borehole_sidetracks do |t|

      t.timestamps null: false
    end
  end
end
