module BoreholesHelper

  def transfer_link(number)
    
    case number
    when nil
      return number
    else
      borehole = try  Borehole.find(number.to_i)
      unless borehole.nil?
        return link_to number, borehole
      else
        return number
      end
    end
  end
end
