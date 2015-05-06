class CreateHandlers < ActiveRecord::Migration
  def change
    create_table :handlers do |t|
      t.string :action
      t.string :data_transferred_to
      t.string :olr_status
      t.string :olr_comment

      t.timestamps null: false
    end
  end
end
