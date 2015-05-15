class AddIndicesToBoreholes < ActiveRecord::Migration
  def change
    add_index :boreholes, :eno
    add_index :boreholes, :entity_type
    add_index :boreholes, :entityid
  end
end
