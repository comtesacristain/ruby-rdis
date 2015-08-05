class CreateBoreholeWdataOne < ActiveRecord::Migration
  def change
    create_table :borehole_wdata_ones do |t|
      t.string :uno
      t.string :code
      t.string :testtype
      t.decimal :top
      t.decimal :bottom
      t.integer :samples
      t.string :remark
      t.datetime :rec_date
      t.datetime :updated
      t.string :db_source
      t.string :sidetrack
      t.integer :eno
      t.string :access_code
      t.integer :ano
    end
  end
end
