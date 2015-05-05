class Entity < ActiveRecord::Base


	self.table_name = "a.entities"
  self.primary_ket = :eno
	set_date_columns :entrydate, :qadate, :lastupdate, :effective_date, :acquisition_date, :expiry_date

end
