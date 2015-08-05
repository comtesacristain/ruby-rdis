class CreateBoreholeWdataTwo < ActiveRecord::Migration
  def change
    create_table :borehole_wdata_twos do |t|
      t.string :uno
      t.string :code
      t.integer :sequence
      t.decimal :top
      t.decimal :bottom
      t.decimal :recovery
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
