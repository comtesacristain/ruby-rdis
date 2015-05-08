module DuplicatesHelper

	def print_wells(well)
		if well.nil?
			return content_tag :td, 'NO WELL DATA', :colspan=>9, :class=>:nowell
		else

			ary = [well.welltype,well.operator,well.purpose,well.status,well.classification,well.start_date, well.completion_date, well.originator, well.total_depth]
			ary.collect do |i|
				content_tag(:td,i)
			end.join.html_safe
			
		end


	end

	def get_row_class(auto_remediation)
		case auto_remediation
		when "DELETE"
			return :delete
		when "KEEP"
			return :keep
		when nil
			return :unknown
		end
	end 
end
