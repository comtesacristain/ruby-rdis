class Borehole < ActiveRecord::Base

		
	has_many :borehole_duplicates
	has_many :duplicates, :through => :borehole_duplicates
  
  has_one :handler
  
  has_one :borehole_well
  has_many :borehole_samples
  
  def entity
    return Entity.find(self.eno)
  end
end
