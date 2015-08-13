class CoreDatum < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"
  
	self.table_name = "npd.core_data"
  self.primary_key = :eno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	belongs_to :entity
end
