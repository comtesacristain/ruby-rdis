class AddQualifierToBorehole < ActiveRecord::Migration
  def change
    add_column :boreholes, :qualifier, :string
  end
end
