class AddColumnsToBoreholeWells < ActiveRecord::Migration
  def change
    add_column :borehole_wells, :eno, :integer
    add_column :borehole_wells, :well_type, :string
    add_column :borehole_wells, :purpose, :string
    add_column :borehole_wells, :on_off, :string
    add_column :borehole_wells, :title, :string
    add_column :borehole_wells, :classification, :string
    add_column :borehole_wells, :status, :string
    add_column :borehole_wells, :ground_elev, :float
    add_column :borehole_wells, :operator, :string
    add_column :borehole_wells, :uno, :string
    add_column :borehole_wells, :start_date, :date
    add_column :borehole_wells, :completion_date, :date
    add_column :borehole_wells, :comments, :string
    add_column :borehole_wells, :total_depth, :float
    add_column :borehole_wells, :originator, :string
    add_column :borehole_wells, :origno, :integer
    
    
         
    
    add_reference :borehole_wells, :borehole
    
    add_index :borehole_wells, :eno
  end
end
