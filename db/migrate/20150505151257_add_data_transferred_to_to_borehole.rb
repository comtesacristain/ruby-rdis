class AddDataTransferredToToBorehole < ActiveRecord::Migration
  def change
    add_column :boreholes, :data_transferred_to, :integer
  end
end
