class AddFinalStatusToHandlers < ActiveRecord::Migration
  def change
    add_column :handlers, :final_status, :string
  end
end
