class BoreholeMineralAttributesController < ApplicationController
  def index
    @columns = BoreholeMineralAttribute.column_names
    @mineral_attributes = BoreholeMineralAttribute.all
    respond_to do |format|
      format.xlsx
    end
  end
end
