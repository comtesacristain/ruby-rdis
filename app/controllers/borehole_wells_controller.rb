class BoreholeWellsController < ApplicationController
  def index
    @columns = BoreholeWell.column_names
    @records = BoreholeWell.all
    respond_to do |format|
      format.xlsx
    end
  end
end
