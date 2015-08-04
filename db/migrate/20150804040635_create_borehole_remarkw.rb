class CreateBoreholeRemarkw < ActiveRecord::Migration
  def change
    create_table :borehole_remarkws do |t|
      t.string :uno
      t.string :code
      t.integer :sequence
      t.string :remark
      t.datetime :rec_date
      t.datetime :updated
      t.string :db_source
      t.integer :eno
      t.string :access_code
      t.integer :ano
    end
  end
end
