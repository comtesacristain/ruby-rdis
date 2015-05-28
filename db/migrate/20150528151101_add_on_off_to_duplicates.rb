class AddOnOffToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :on_off, :integer
  end
end
