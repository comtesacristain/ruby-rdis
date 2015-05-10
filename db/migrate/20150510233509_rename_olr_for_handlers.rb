class RenameOlrForHandlers < ActiveRecord::Migration
  def change
    rename_column :handlers, :olr_status, :or_status
    rename_column :handlers, :olr_transfer, :or_transfer
     rename_column :handlers, :olr_comment, :or_comment
  end
end
