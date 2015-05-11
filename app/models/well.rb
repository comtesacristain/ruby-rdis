class Well < ActiveRecord::Base

	self.table_name = "npm.wells"
    self.primary_key = :eno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
  has_many :well_confids, :foreign_key => :eno
	belongs_to :entity
end