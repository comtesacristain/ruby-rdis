class AddActionToBorehole < ActiveRecord::Migration
  def change
    add_column :boreholes, :action, :string
  end
end
