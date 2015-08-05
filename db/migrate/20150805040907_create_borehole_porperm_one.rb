class CreateBoreholePorpermOne < ActiveRecord::Migration
  def change
    create_table :borehole_porperm_ones do |t|
      t.string :well
      t.string :andate
      t.string :genfile
      t.string :wellfile
      t.string :remarks
      t.string :uno
      t.decimal :latit
      t.decimal :longit
      t.integer :eno
      t.string :access_code
      t.integer :ano
    end
  end
end
