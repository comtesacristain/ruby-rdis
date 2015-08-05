class CreatePopermTwos < ActiveRecord::Migration
  def change
    create_table :poperm_twos do |t|

      t.timestamps null: false
    end
  end
end
