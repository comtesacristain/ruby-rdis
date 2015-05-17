class CreateBoreholeSamples < ActiveRecord::Migration
  def change
    create_table :borehole_samples do |t|

      t.timestamps null: false
    end
  end
end
