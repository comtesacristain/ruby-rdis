class Duplicate < ActiveRecord::Base
  establish_connection :local
  belongs_to :duplicate_group

  def entity
    return Entity.find(self.eno)
  end
end
