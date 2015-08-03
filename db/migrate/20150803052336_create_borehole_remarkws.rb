class CreateBoreholeRemarkws < ActiveRecord::Migration
  def change
    create_table :borehole_remarkws do |t|
      t.string :uno
      t.integer :eno

      t.timestamps null: false
    end
  end
end
