class CreateBoreholeResultw < ActiveRecord::Migration
  def change
    create_table :borehole_resultws do |t|
      t.string :uno
      t.string :type
      t.string :reference
      t.string :location
      t.datetime :release
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
