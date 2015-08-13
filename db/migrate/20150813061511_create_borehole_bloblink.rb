class CreateBoreholeBloblink < ActiveRecord::Migration
  def change
    create_table :borehole_bloblinks do |t|
      t.integer :bloblinkno
      t.string :source_owner
      t.string :source_table
      t.string :source_column
      t.integer :source_no
      t.integer :blobno
      t.string :remark
      t.string :access_code
      t.integer :ano
      t.datetime :entrydate
      t.string :enteredby
      t.datetime :lastupdate
      t.string :updatedby
      t.datetime :qadate
      t.string :qaby
      t.string :qa_status_code
      t.string :activity_code
    end
  end
end
