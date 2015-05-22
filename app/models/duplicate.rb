class Duplicate < ActiveRecord::Base


	has_many :borehole_duplicates
	has_many :boreholes, :through => :borehole_duplicates
  has_many :handlers, :through => :boreholes
  
  accepts_nested_attributes_for :handlers

  # DELETE the following when done
  

  def has_remediation
    if Rails.env=="development"
      return @auto_remediation
    else
      return @has_remediation
    end
  end
  
  def manual_remediation
    if Rails.env=="development"
      return @qaed
    else
      return @manual_remediation
    end
  end

end
