class CreateBoreholeCoreDatum < ActiveRecord::Migration
  def change
    create_table :borehole_core_data do |t|
      t.string :uno
      t.string :name
      t.string :bmr_file_no
      t.string :psla_no
      t.string :location
      t.string :legsln
      t.decimal :num_boxes
      t.decimal :total_boxes
      t.decimal :num_boxes_prev
      t.string :print_label
      t.string :t_type
      t.integer :eno
      t.string :access_code
      t.integer :ano
    end
  end
end
