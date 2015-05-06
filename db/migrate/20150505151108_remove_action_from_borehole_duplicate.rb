class RemoveActionFromBoreholeDuplicate < ActiveRecord::Migration
  def change
    remove_column :borehole_duplicates, :action, :string
  end
end
