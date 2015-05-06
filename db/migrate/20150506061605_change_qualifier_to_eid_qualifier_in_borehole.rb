class ChangeQualifierToEidQualifierInBorehole < ActiveRecord::Migration
  def change
	rename_column :boreholes, :qualifier, :eid_qualifier
  end
end
