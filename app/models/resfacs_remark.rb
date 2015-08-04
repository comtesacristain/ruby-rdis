class ResfacsRemark < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"
  
	self.table_name = "resfacs.rfs_rmks"
  self.primary_key = :rfs_rmksno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	belongs_to :entity
end
