class Resultw < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"
  
	self.table_name = "npd.npd_resultw"
  self.primary_key = :eno
	#set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date
	belongs_to :entity
  
  class << self
    def instance_method_already_implemented?(method_name)
      return true if method_name =~ /type/
      super
    end
  end
  
end