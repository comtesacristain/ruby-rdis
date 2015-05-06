class ChangeDuplicateGroupIdToDuplicateId < ActiveRecord::Migration
  def change
    rename_column :borehole_duplicates, :duplicate_group_id, :duplicate_id  
end
end
