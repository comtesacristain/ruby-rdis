class AddColumnsToBoreholeEntityAttributes < ActiveRecord::Migration
  def change
    add_column :borehole_entity_attributes, :attribno, :integer
    add_column :borehole_entity_attributes, :eno, :integer
    add_column :borehole_entity_attributes, :attr, :string #Attribute
    add_column :borehole_entity_attributes, :num_value, :float #Attribute
    add_column :borehole_entity_attributes, :text_value, :string #Attribute
    add_column :borehole_entity_attributes, :date_value, :date #Attribute
    
    
         
    
    add_reference :borehole_entity_attributes, :borehole
    
    add_index :borehole_entity_attributes, :eno
  end
end
