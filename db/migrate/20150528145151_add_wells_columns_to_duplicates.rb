class AddWellsColumnsToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :welltype, :integer
    add_column :duplicates, :purpose, :integer
    add_column :duplicates, :title, :integer
    add_column :duplicates, :classification, :integer
    add_column :duplicates, :status, :integer
    add_column :duplicates, :ground_elev, :integer
    add_column :duplicates, :operator, :integer
    add_column :duplicates, :uno, :integer
    add_column :duplicates, :start_date, :integer
    add_column :duplicates, :completion_date, :integer
    add_column :duplicates, :total_depth, :integer
    add_column :duplicates, :originator, :integer
    add_column :duplicates, :origno, :integer
  end
end
