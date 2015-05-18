class AddColumnsToBoreholeMineralAttributes < ActiveRecord::Migration
  def change
   
    add_column :borehole_mineral_attributes, :attribno, :integer
    add_column :borehole_mineral_attributes, :eno, :integer
    add_column :borehole_mineral_attributes, :attr, :string #Attribute
    add_column :borehole_mineral_attributes, :num_value, :float 
    add_column :borehole_mineral_attributes, :text_value, :string 
    add_column :borehole_mineral_attributes, :date_value, :date 
    
         
    
    add_reference :borehole_mineral_attributes, :borehole
    
    add_index :borehole_mineral_attributes, :eno
  end
end
