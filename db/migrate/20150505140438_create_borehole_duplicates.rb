class CreateBoreholeDuplicates < ActiveRecord::Migration
  def change
    create_table :borehole_duplicates do |t|
      t.references :borehole, index: true, foreign_key: true
      t.references :duplicate_group, index: true, foreign_key: true
      t.string :action

      t.timestamps null: false
    end
  end
end
