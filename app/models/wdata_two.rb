class WdataTwo < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"
  
	self.table_name = "npd.npd_wdata2"
  self.primary_key = :eno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	belongs_to :entity
  
  self.inheritance_column = nil 
  
end