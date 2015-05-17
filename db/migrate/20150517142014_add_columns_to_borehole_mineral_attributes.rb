class AddColumnsToBoreholeMineralAttributes < ActiveRecord::Migration
  def change
   
    add_column :borehole_mineral_attributes, :attribno, :integer
    add_column :borehole_mineral_attributes, :eno, :integer
    add_column :borehole_mineral_attributes, :attr, :string #Attribute
    add_column :borehole_mineral_attributes, :num_value, :float #Attribute
    add_column :borehole_mineral_attributes, :text_value, :string #Attribute
    add_column :borehole_mineral_attributes, :date_value, :date #Attribute
    
         
    
    add_reference :borehole_mineral_attributes, :borehole
    
    add_index :borehole_mineral_attributes, :eno
  end
end
