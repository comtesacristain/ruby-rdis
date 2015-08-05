class BoreholeWell < ActiveRecord::Base
  belongs_to :borehole, :foreign_key => :eno
end
