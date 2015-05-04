class CreateDuplicates < ActiveRecord::Migration
  def change
    create_table :duplicates do |t|
      t.integer :eno
      t.string :entity_type
      t.string :entityid
      t.float :x
      t.float :y
      t.float :z
      t.string :has_well
      t.string :has_samples
      t.integer :no_samples
      t.string :action
      t.references :duplicate_group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
