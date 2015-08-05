class BoreholeMineralAttributesController < ApplicationController
  def index
    @columns = BoreholeMineralAttribute.column_names
    @borehole_mineral_attributes = BoreholeMineralAttribute.all
    respond_to do |format|
      format.xlsx
    end
  end
end
