class DuplicateGroup < ActiveRecord::Base
  establish_connection :local
  has_many :duplicates
end
