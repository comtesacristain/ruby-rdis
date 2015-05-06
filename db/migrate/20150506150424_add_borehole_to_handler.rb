class AddBoreholeToHandler < ActiveRecord::Migration
  def change
    add_column :handlers, :borehole, :reference
  end
end
