class AddReviewColumnsToHandler < ActiveRecord::Migration
  def change
    add_column :handlers, :or_final_comment, :string
    add_column :handlers, :or_reference, :string
  end
end
