class Entity < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"

	self.table_name = "a.entities"
  self.primary_key = :eno
	
  set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	has_one :well, :foreign_key =>:eno
	has_many :samples, :foreign_key => :eno
  
  has_many :remarkws, :foreign_key => :eno
  has_many :stratigraphies, :foreign_key => :eno
  has_many :resfacs_remarks, :foreign_key => :eno
  has_one :sidetrack, :foreign_key => :eno
  
  has_many :entity_attributes, :foreign_key => :eno
  has_many :mineral_attributes, :foreign_key => :eno
end
