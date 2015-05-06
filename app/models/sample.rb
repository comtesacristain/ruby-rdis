class Sample < ActiveRecord::Base

	self.table_name = "a.samples"
    self.primary_key = :sampleno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	belongs_to :entity
end