class Entity < ActiveRecord::Base


	self.table_name = "a.entities"
  set_primary_key :eno
	set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date

end
