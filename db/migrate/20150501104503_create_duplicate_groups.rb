class CreateDuplicateGroups < ActiveRecord::Migration
  def change
    create_table :duplicate_groups do |t|
      t.string :type

      t.timestamps null: false
    end
  end
end
