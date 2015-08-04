class CreateBoreholeResfacsRemark < ActiveRecord::Migration
  def change
    create_table :borehole_resfacs_remarks do |t|
      t.string :uno
      t.string :code
      t.decimal :seq_no
      t.string :remark
      t.string :sidetrack
      t.integer :eno
      t.string :access_code
      t.integer :ano
      t.decimal :rfs_rmksno
    end
  end
end
