class Entity < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"

	self.table_name = "a.entities"
  self.primary_key = :eno
	
  set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	has_one :well, :foreign_key =>:eno
	has_many :samples, :foreign_key => :eno
  
  has_many :reflinks, :foreign_key => :eno
  has_many :bloblinks, :foreign_key => :source_no
  
  has_many :well_confids, :foreign_key => :eno
  has_many :well_temps, :foreign_key => :eno
  
  has_many :remarkws, :foreign_key => :eno
  has_many :resultws, :foreign_key => :eno
  has_many :dir_surveys, :foreign_key => :eno
  has_many :dir_survey_stations, :foreign_key => :eno
  has_many :stratigraphies, :foreign_key => :eno
  has_many :core_data, :foreign_key => :eno
  has_many :resfacs_remarks, :foreign_key => :eno
  has_one :sidetrack, :foreign_key => :eno
  has_one :porperm_one, :foreign_key => :eno
  has_many :porperm_twos, :foreign_key => :eno
  has_many :porperm_picks, :foreign_key => :eno
  
  has_many :wdata_ones, :foreign_key => :eno
  has_many :wdata_twos, :foreign_key => :eno
  
  has_many :entity_attributes, :foreign_key => :eno
  has_many :mineral_attributes, :foreign_key => :eno
end
