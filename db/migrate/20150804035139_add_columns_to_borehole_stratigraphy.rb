class AddColumnsToBoreholeStratigraphy < ActiveRecord::Migration
  def change
    add_column :borehole_stratigraphies, :picked, :string
    add_column :borehole_stratigraphies, :age1, :string
    add_column :borehole_stratigraphies, :qual1, :string
    add_column :borehole_stratigraphies, :age2, :string
    add_column :borehole_stratigraphies, :qual2, :string
    add_column :borehole_stratigraphies, :unit, :string
    add_column :borehole_stratigraphies, :top_meas_depth_m, :decimal
    add_column :borehole_stratigraphies, :elevation, :decimal
    add_column :borehole_stratigraphies, :meas_thickness_m, :decimal
    add_column :borehole_stratigraphies, :code, :string
    add_column :borehole_stratigraphies, :updated, :datetime
    add_column :borehole_stratigraphies, :rec_date, :datetime
    add_column :borehole_stratigraphies, :db_source, :string
    add_column :borehole_stratigraphies, :unitno, :integer
    add_column :borehole_stratigraphies, :top_vert_depth_m, :decimal
    add_column :borehole_stratigraphies, :eno, :integer
    add_column :borehole_stratigraphies, :access_code, :string
    add_column :borehole_stratigraphies, :ano, :integer
    add_column :borehole_stratigraphies, :unit_qualifier, :string
    add_column :borehole_stratigraphies, :base_meas_depth_m, :decimal
    add_column :borehole_stratigraphies, :sourceno, :integer
    add_column :borehole_stratigraphies, :source_comment, :string
    add_column :borehole_stratigraphies, :enteredby, :string
    add_column :borehole_stratigraphies, :updatedby, :string
    add_column :borehole_stratigraphies, :remarks, :string
    add_column :borehole_stratigraphies, :sampleno, :integer
    add_column :borehole_stratigraphies, :pref_alt, :string
  end
end
