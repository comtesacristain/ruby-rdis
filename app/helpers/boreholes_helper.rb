module BoreholesHelper

  def transfer_link(number)
    
    case number
    when nil
      return number
    else
      borehole = Borehole.find(number.to_i)
      unless borehole.nil?
        return link_to number, borehole
      else
        return number
      end
    end
  end
  
	def print_wells(well)
		if well.nil?
			return content_tag :td, 'NO WELL DATA', :colspan=>9, :class=>:nowell
		else
			ary = get_wells_row(well)
			ary.collect do |i|
				content_tag(:td,i)
			end.join.html_safe
		end
	end
  
	def get_wells_row(well)
    if well.nil?
      row=  Array.new(9)
		else
			row = [well.welltype,well.operator,well.purpose,well.status,well.classification,well.start_date, well.completion_date, well.originator, well.total_depth]
			
		end
    return row
	end
  
  
end
