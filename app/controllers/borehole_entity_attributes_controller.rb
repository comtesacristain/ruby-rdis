class BoreholeEntityAttributesController < ApplicationController
  def index
    klass = BoreholeEntityAttribute
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
