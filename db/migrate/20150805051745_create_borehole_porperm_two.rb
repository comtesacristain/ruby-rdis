class CreateBoreholePorpermTwo < ActiveRecord::Migration
  def change
    create_table :borehole_porperm_twos do |t|
      t.string :well
      t.integer :coreno
      t.string :matrix
      t.string :grain
      t.string :comments
      t.decimal :poroh
      t.decimal :porov
      t.decimal :permh
      t.decimal :permv
      t.decimal :depav
      t.decimal :porav
      t.string :uno
      t.string :rock1
      t.string :rock2
      t.string :pick
      t.string :age1
      t.string :age2
      t.string :unit
      t.decimal :depth
      t.string :basin
      t.integer :eno
      t.string :access_code
      t.integer :ano
    end
  end
end
