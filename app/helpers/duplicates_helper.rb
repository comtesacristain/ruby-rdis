module DuplicatesHelper
  
	def get_wells_row(well)
    if well.nil?
      row=  Array.new(9)
		else
			row = [well.welltype,well.operator,well.purpose,well.status,well.classification,well.start_date, well.completion_date, well.originator, well.total_depth]
			
		end
    return row
	end

	def get_row_class(remediation)
		case remediation
		when "DELETE"
			return :delete
		when "KEEP"
			return :keep
		when nil
			return :unknown
		end
	end
  
  def remediated_well
    well_picks = [ :welltype, :purpose, :on_off, :title, :classification, :status, :ground_elev, :operator, :uno, :start_date, :completion_date, :comments, :total_depth, :originator, :origno]
    well_picks.collect do |wp|
      content_tag(:td,@wells.find_by(eno:@duplicate[wp])[wp])
    end.join.html_safe
  end

  
  
  def create_duplicate_pattern(boreholes)
    ary=Array.new
    keep = boreholes.joins(:handler).where(:handlers=>{:auto_remediation => 'KEEP'})
    keep.each do |k|
      h=Hash.new
      delete = boreholes.joins(:handler).where(:handlers=>{:auto_transfer => k.eno})
      h[:keep] = k
      h[:delete] =delete
      ary.push(h)
    end
    return ary
  end 
  
  def tick_or_cross(a)
    case a
    when "Y"
      return  "&#x2713;"
    when "N"
      return   "&#x2717;"
    when nil
      return "&nbsp;"
    end
  end
  
  def yes_no_all
    return {"All"=>nil,"Yes"=>"Y","No"=>"N"}
  end
  
  def yes_no_nil
    return {nil=>nil,"Yes"=>"Y","No"=>"N"}
  end
  
  def deleted_boreholes
    return @duplicate.boreholes.includes(:handler).where(handlers:{manual_remediation:"DELETE"})
  end
  
  def auto_approve_check
    if @duplicate.auto_approved == "Y"
      return "Their automatic remediation has been approved."
    elsif @duplicate.auto_approved == "N"
      return "Their automatic remediation has not been approved."
    else
      return "Their automatic remediation status is unknown."
    end
  end
 
  
  
end
