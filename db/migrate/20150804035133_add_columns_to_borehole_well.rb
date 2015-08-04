class AddColumnsToBoreholeWell < ActiveRecord::Migration
  def change
    add_column :borehole_wells, :eno, :integer
    add_column :borehole_wells, :welltype, :string
    add_column :borehole_wells, :purpose, :string
    add_column :borehole_wells, :on_off, :string
    add_column :borehole_wells, :title, :string
    add_column :borehole_wells, :classification, :string
    add_column :borehole_wells, :status, :string
    add_column :borehole_wells, :ground_elev, :decimal
    add_column :borehole_wells, :operator, :string
    add_column :borehole_wells, :uno, :string
    add_column :borehole_wells, :start_date, :datetime
    add_column :borehole_wells, :completion_date, :datetime
    add_column :borehole_wells, :comments, :string
    add_column :borehole_wells, :access_code, :string
    add_column :borehole_wells, :ano, :integer
    add_column :borehole_wells, :entrydate, :datetime
    add_column :borehole_wells, :enteredby, :string
    add_column :borehole_wells, :lastupdate, :datetime
    add_column :borehole_wells, :updatedby, :string
    add_column :borehole_wells, :total_depth, :decimal
    add_column :borehole_wells, :originator, :string
    add_column :borehole_wells, :qadate, :datetime
    add_column :borehole_wells, :qaby, :string
    add_column :borehole_wells, :qa_status_code, :string
    add_column :borehole_wells, :activity_code, :string
    add_column :borehole_wells, :file_no, :string
    add_column :borehole_wells, :state, :string
    add_column :borehole_wells, :confid_until, :datetime
    add_column :borehole_wells, :origno, :integer
  end
end
