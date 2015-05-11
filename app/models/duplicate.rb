class Duplicate < ActiveRecord::Base
	establish_connection :local

	has_many :borehole_duplicates
	has_many :boreholes, :through => :borehole_duplicates
  has_many :handlers, :through => :boreholes
  
  accepts_nested_attributes_for :handlers
end
