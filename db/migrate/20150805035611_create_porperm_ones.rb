class CreatePorpermOnes < ActiveRecord::Migration
  def change
    create_table :porperm_ones do |t|

      t.timestamps null: false
    end
  end
end
