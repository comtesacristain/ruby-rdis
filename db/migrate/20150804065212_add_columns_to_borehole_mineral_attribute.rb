class AddColumnsToBoreholeMineralAttribute < ActiveRecord::Migration
  def change
    add_column :borehole_mineral_attributes, :eno, :integer
    add_column :borehole_mineral_attributes, :a_attribute, :string
    add_column :borehole_mineral_attributes, :num_value, :decimal
    add_column :borehole_mineral_attributes, :date_value, :datetime
    add_column :borehole_mineral_attributes, :uom, :string
    add_column :borehole_mineral_attributes, :access_code, :string
    add_column :borehole_mineral_attributes, :entrydate, :date
    add_column :borehole_mineral_attributes, :enteredby, :string
    add_column :borehole_mineral_attributes, :lastupdate, :date
    add_column :borehole_mineral_attributes, :updatedby, :string
    add_column :borehole_mineral_attributes, :text_value, :string
    add_column :borehole_mineral_attributes, :ano, :integer
    add_column :borehole_mineral_attributes, :comments, :string
    add_column :borehole_mineral_attributes, :attribno, :integer
    add_column :borehole_mineral_attributes, :year, :integer
    add_column :borehole_mineral_attributes, :confid_until, :date
  end
end
