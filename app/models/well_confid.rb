class WellConfid < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"
  
	self.table_name = "holes.wells_confid"
  self.primary_key = :eno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	belongs_to :well
end