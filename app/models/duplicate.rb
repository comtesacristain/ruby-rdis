class Duplicate < ActiveRecord::Base
  establish_connection :local
  belongs_to :duplicate_group
end
