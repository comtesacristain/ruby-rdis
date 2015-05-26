class Duplicate < ActiveRecord::Base


	has_many :borehole_duplicates
	has_many :boreholes, :through => :borehole_duplicates
  has_many :handlers, :through => :boreholes
  
  has_many :wells, :through => :boreholes, :class_name => "BoreholeWell"
  
  accepts_nested_attributes_for :handlers


end
