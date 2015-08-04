class AddColumnsToBoreholeEntityAttribute < ActiveRecord::Migration
  def change
    add_column :borehole_entity_attributes, :eno, :integer
    add_column :borehole_entity_attributes, :a_attribute, :string
    add_column :borehole_entity_attributes, :num_value, :decimal
    add_column :borehole_entity_attributes, :date_value, :datetime
    add_column :borehole_entity_attributes, :access_code, :string
    add_column :borehole_entity_attributes, :entrydate, :date
    add_column :borehole_entity_attributes, :enteredby, :string
    add_column :borehole_entity_attributes, :lastupdate, :date
    add_column :borehole_entity_attributes, :updatedby, :string
    add_column :borehole_entity_attributes, :text_value, :string
    add_column :borehole_entity_attributes, :ano, :integer
    add_column :borehole_entity_attributes, :remark, :string
    add_column :borehole_entity_attributes, :attribno, :integer
    add_column :borehole_entity_attributes, :confid_until, :date
  end
end
