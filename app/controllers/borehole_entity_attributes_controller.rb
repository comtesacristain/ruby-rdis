class BoreholeEntityAttributesController < ApplicationController
  def index
    @columns = BoreholeEntityAttribute.column_names
    @records = BoreholeEntityAttribute.all
    respond_to do |format|
      format.xlsx
    end
  end
end
