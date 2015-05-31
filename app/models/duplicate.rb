class Duplicate < ActiveRecord::Base


	has_many :borehole_duplicates
	has_many :boreholes, :through => :borehole_duplicates
  has_many :handlers, :through => :boreholes
  
  has_many :wells, :through => :boreholes, :class_name => "BoreholeWell"
  
  accepts_nested_attributes_for :handlers

  def well_picks 
    return [ :welltype, :purpose, :on_off, :title, :classification, :status, :ground_elev, :operator, :uno, :start_date, :completion_date, :comments, :total_depth, :originator, :origno]
  end 
  
  def borehole_picks
    return [:geom_original, :access_code, :eid_qualifier, :remark, :acquisition_methodno]
  end

  def pick_kept
    borehole = self.boreholes.includes(:handler).find_by(handlers:{auto_remediation:"KEEP"})
    self.keep = borehole.eno
  end
  
  def pick_all
    pick_boreholes
    pick_wells
  end

  
  def pick_boreholes
    borehole_picks.each do |bp| 
      boreholes = self.boreholes.select do |b|
        case bp
        when :access_code
          if b[bp] == "C"
            b
          elsif b[bp] == "A"
            b
          end
        when :geom_original
          !b[:z].nil?
        else
          !b[bp].nil?
        end
      end
      if boreholes.size == 1
        self[bp] = boreholes.first.eno
      else
        self[bp] = self.keep
      end
      self.save
    end
  end
  
  def pick_wells
    well_picks.each do |wp|
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
