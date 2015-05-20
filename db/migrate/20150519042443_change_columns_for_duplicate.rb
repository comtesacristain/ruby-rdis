class ChangeColumnsForDuplicate < ActiveRecord::Migration
  def change
    add_column :duplicates, :comments, :string
  end
end
