class CreateDuplicateGroups < ActiveRecord::Migration
  def change
    create_table :duplicate_groups do |t|
      t.string :kind

      t.timestamps null: false
    end
  end
end
