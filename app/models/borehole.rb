class Borehole < ActiveRecord::Base

		
	has_many :borehole_duplicates
	has_many :duplicates, :through => :borehole_duplicates
  
  has_one :handler
  
  has_one :well, :class_name => "BoreholeWell"
  has_many :samples, :class_name => "BoreholeSample"
  has_many :entity_attributes, :class_name => "BoreholeEntityAttributes"
  has_many :mineral_attributes, :class_name => "BoreholeMineralAttributes"
  
  def entity
    return Entity.find(self.eno)
  end
end
