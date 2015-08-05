class Borehole < ActiveRecord::Base

		
	has_many :borehole_duplicates
	has_many :duplicates, :through => :borehole_duplicates
  
  has_one :handler
  
  has_one :well, :class_name => "BoreholeWell", :foreign_key => :eno, :primary_key => :eno
  has_many :well_confids, :class_name => "BoreholeWellConfid", :foreign_key => :eno, :primary_key => :eno
  has_many :samples, :class_name => "BoreholeSample", :foreign_key => :eno
  has_many :entity_attributes, :class_name => "BoreholeEntityAttributes", :foreign_key => :eno
  has_many :mineral_attributes, :class_name => "BoreholeMineralAttributes", :foreign_key => :eno
  
  
  
  
  
  
  has_many :remarkws, :class_name => "BoreholeRemark", :foreign_key => :eno
  has_many :resultws, :class_name => "BoreholeResultw", :foreign_key => :eno
  has_many :dir_surveys, :class_name => "BoreholeDirSurvey", :foreign_key => :eno
  has_many :dir_survey_stations, :class_name => "BoreholeDirSurveyStation", :foreign_key => :eno
  has_many :stratigraphies, :class_name => "BoreholeStratigraphy", :foreign_key => :eno
  has_many :resfacs_remarks,:class_name => "BoreholeRefacsRemark",  :foreign_key => :eno
  has_one :sidetrack, :class_name => "BoreholeSidetrack", :foreign_key => :eno
  has_one :porperm_one, :class_name => "BoreholePorpermOne", :foreign_key => :eno
  has_many :porperm_twos, :class_name => "BoreholePorpermTwo", :foreign_key => :eno
  has_many :porperm_picks, :class_name => "BoreholePorpermPick", :foreign_key => :eno
  
  has_many :wdata_ones, :class_name => "BoreholeWdataOne",  :foreign_key => :eno
  has_many :wdata_twos, :class_name => "BoreholeWdataTwo", :foreign_key => :eno

  def entity
    return Entity.find(self.eno)
  end
end
