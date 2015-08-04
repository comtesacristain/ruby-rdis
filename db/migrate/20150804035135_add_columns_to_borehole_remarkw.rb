class AddColumnsToBoreholeRemarkw < ActiveRecord::Migration
  def change
    add_column :borehole_remarkws, :uno, :string
    add_column :borehole_remarkws, :code, :string
    add_column :borehole_remarkws, :sequence, :integer
    add_column :borehole_remarkws, :remark, :string
    add_column :borehole_remarkws, :rec_date, :datetime
    add_column :borehole_remarkws, :updated, :datetime
    add_column :borehole_remarkws, :db_source, :string
    add_column :borehole_remarkws, :eno, :integer
    add_column :borehole_remarkws, :access_code, :string
    add_column :borehole_remarkws, :ano, :integer
  end
end
