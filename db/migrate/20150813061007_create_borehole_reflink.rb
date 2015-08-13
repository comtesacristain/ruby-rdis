class CreateBoreholeReflink < ActiveRecord::Migration
  def change
    create_table :borehole_reflinks do |t|
      t.integer :eno
      t.integer :refid
      t.string :enteredby
      t.datetime :entrydate
      t.datetime :lastupdate
      t.string :updatedby
    end
  end
end
