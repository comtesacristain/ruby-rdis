class CreateSidetracks < ActiveRecord::Migration
  def change
    create_table :sidetracks do |t|

      t.timestamps null: false
    end
  end
end
