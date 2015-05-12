class BoreholeDuplicate < ActiveRecord::Base

  belongs_to :borehole
  belongs_to :duplicate
end
