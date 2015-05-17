class AddColumnsToBoreholeSamples < ActiveRecord::Migration
  def change
    add_column :borehole_samples, :sampleno, :integer
    add_column :borehole_samples, :eno, :integer
    add_column :borehole_samples, :sampleid, :string
    add_column :borehole_samples, :sample_type, :string
    add_column :borehole_samples, :top_depth, :float
    add_column :borehole_samples, :base_depth, :float
    add_column :borehole_samples, :parent, :integer
    add_column :borehole_samples, :originator, :string
    add_column :borehole_samples, :acquiredate, :date
    add_column :borehole_samples, :geom_original, :string

    
    add_reference :borehole_samples, :borehole
    
    add_index :borehole_samples, :eno
  end
end
