class CreateBoreholePorpermPick < ActiveRecord::Migration
  def change
    create_table :borehole_porperm_picks do |t|
      t.string :uno
      t.string :pick
      t.integer :eno
      t.string :access_code
      t.integer :ano
    end
  end
end
