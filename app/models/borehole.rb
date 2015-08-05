class Borehole < ActiveRecord::Base

		
	has_many :borehole_duplicates
	has_many :duplicates, :through => :borehole_duplicates
  
  has_one :handler
  
  has_one :well, :class_name => "BoreholeWell", :foreign_key => :eno
  has_many :samples, :class_name => "BoreholeSample", :foreign_key => :eno
  has_many :entity_attributes, :class_name => "BoreholeEntityAttributes", :foreign_key => :eno
  has_many :mineral_attributes, :class_name => "BoreholeMineralAttributes", :foreign_key => :eno
  
  def entity
    return Entity.find(self.eno)
  end
end
