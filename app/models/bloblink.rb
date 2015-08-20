class Bloblink < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"
  
	self.table_name = "npm.bloblink"
  self.primary_key = :bloblinkno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	belongs_to :entity

	alias_attribute :eno, :source_no
	end