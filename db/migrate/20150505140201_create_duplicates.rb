class CreateDuplicates < ActiveRecord::Migration
  def change
    create_table :duplicates do |t|
      t.string :kind
      t.string :has_resolution
      t.string :qaed

      t.timestamps null: false
    end
  end
end
