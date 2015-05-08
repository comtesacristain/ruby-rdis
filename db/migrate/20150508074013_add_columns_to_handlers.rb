class AddColumnsToHandlers < ActiveRecord::Migration
  def change
    add_column :handlers, :manual_remediation, :string
    add_column :handlers, :manual_transfer, :integer
  end
end
