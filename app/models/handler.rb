class Handler < ActiveRecord::Base
  establish_connection :local
  belongs_to :borehole
end
