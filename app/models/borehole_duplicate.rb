class BoreholeDuplicate < ActiveRecord::Base
	establish_connection :local
  belongs_to :borehole
  belongs_to :duplicate
end
