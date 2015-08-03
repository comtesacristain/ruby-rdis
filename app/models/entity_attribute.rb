class EntityAttribute < ActiveRecord::Base
  establish_connection "oracle_#{Rails.env}"

  self.table_name = "a.entity_attribs"
  self.primary_key = :eno
  set_date_columns :entrydate, :qadate, :confid_until, :lastupdate

  class << self
    def instance_method_already_implemented?(method_name)
      return true if method_name =~ /attribute/
      super
    end
  end

end
