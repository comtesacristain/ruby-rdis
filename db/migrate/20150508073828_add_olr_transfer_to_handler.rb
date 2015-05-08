class AddOlrTransferToHandler < ActiveRecord::Migration
  def change
    add_column :handlers, :olr_transfer, :integer
  end
end
