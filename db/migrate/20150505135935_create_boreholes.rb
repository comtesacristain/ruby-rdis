class CreateBoreholes < ActiveRecord::Migration
  def change
    create_table :boreholes do |t|
      t.integer :eno
      t.string :entityid
      t.string :entity_type
      t.float :x
      t.float :y
      t.float :z
      t.string :access_code
      t.date :confid_until
      t.string :qa_status_code
      t.string :qadate
      t.integer :acquisition_methodno
      t.string :geom_original
      t.integer :parent
      t.string :remark

      t.timestamps null: false
    end
  end
end
