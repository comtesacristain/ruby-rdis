class AddColumnsToBoreholeSidetrack < ActiveRecord::Migration
  def change
    add_column :borehole_sidetracks, :uno, :string
    add_column :borehole_sidetracks, :sidetrack, :string
    add_column :borehole_sidetracks, :ko_depth, :decimal
    add_column :borehole_sidetracks, :td_driller, :decimal
    add_column :borehole_sidetracks, :td_logs, :decimal
    add_column :borehole_sidetracks, :tvd, :decimal
    add_column :borehole_sidetracks, :metres_drilled, :decimal
    add_column :borehole_sidetracks, :db_source, :string
    add_column :borehole_sidetracks, :rec_date, :datetime
    add_column :borehole_sidetracks, :updated, :datetime
    add_column :borehole_sidetracks, :eno, :integer
    add_column :borehole_sidetracks, :access_code, :string
    add_column :borehole_sidetracks, :ano, :integer
  end
end
