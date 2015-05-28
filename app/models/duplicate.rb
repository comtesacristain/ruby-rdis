class Duplicate < ActiveRecord::Base


	has_many :borehole_duplicates
	has_many :boreholes, :through => :borehole_duplicates
  has_many :handlers, :through => :boreholes
  
  has_many :wells, :through => :boreholes, :class_name => "BoreholeWell"
  
  accepts_nested_attributes_for :handlers

  def well_picks 
    return [ :welltype, :purpose, :on_off, :title, :classification, :status, :ground_elev, :operator, :uno, :start_date, :completion_date, :comments, :total_depth, :originator, :origno]
  end 

  def pick_kept
    borehole = self.boreholes.includes(:handler).find_by(handlers:{auto_remediation:"KEEP"})
    self.keep = borehole.eno
  end

  def pick_geom_original
    boreholes = self.boreholes.select{|b| !b.z.nil?}
    if boreholes.size == 1
      self.geom_original = boreholes.first.eno
    else
      self.geom_original = self.keep
    end
    self.save
  end

  def pick_access_code
    boreholes = self.boreholes.select do |b|
      case b.access_code
      when "C"
        b
      when "A"
        b
      end
    end
    if boreholes.size == 1
      self.access_code = boreholes.first.eno
    else
       self.access_code = self.keep
    end
    self.save
  end
  
  def pick_qualifier
    boreholes = self.boreholes.select do |b|
      !b.eid_qualifier.nil?
    end
    if boreholes.size == 1
      self.eid_qualifier = boreholes.first.eno
    else
       self.eid_qualifier = self.keep
    end
    self.save
  end
  
  
  def pick_remark
    boreholes = self.boreholes.select do |b|
      !b.remark.nil?
    end
    if boreholes.size == 1
      self.remark = boreholes.first.eno
    else
      self.remark = self.keep
    end
    self.save
  end
  
  def pick_wells
    @well_picks.each do |wp|
      wells = self.wells.select do |w|
        !w[wp].nil?
      end
      if wells.size == 1
        self[wp] = wells.first.eno
      else
        self[wp] = self.keep
      end
      self.save
    end
  end
end
