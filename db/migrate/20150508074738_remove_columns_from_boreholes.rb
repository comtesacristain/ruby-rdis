class RemoveColumnsFromBoreholes < ActiveRecord::Migration
  def change
    remove_column :boreholes, :data_transferred_to
    remove_column :boreholes, :action
  end
end
