class Borehole < ActiveRecord::Base
	establish_connection :local
		

		has_many :borehole_duplicates
	has_many :duplicates, :through => :borehole_duplicates
  def entity
    return Entity.find(self.eno)
  end
end
