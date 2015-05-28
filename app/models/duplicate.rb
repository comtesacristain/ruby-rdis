class Duplicate < ActiveRecord::Base


	has_many :borehole_duplicates
	has_many :boreholes, :through => :borehole_duplicates
  has_many :handlers, :through => :boreholes
  
  has_many :wells, :through => :boreholes, :class_name => "BoreholeWell"
  
  accepts_nested_attributes_for :handlers


  def pick_kept
    borehole = self.boreholes.includes(:handler).find_by(handlers:{auto_remediation:"KEEP"})
    self.keep = borehole.eno
  end

  def pick_geom_original
    boreholes = self.boreholes.select{|b| !b.z.nil?}
    if boreholes.size == 1
      self.geom_original = boreholes.first.eno
    else
      return self.geom_original = self.keep
    end
    self.save
  end


end
