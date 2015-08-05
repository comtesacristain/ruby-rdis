class BoreholeWellsController < ApplicationController
  def index
    @columns = BoreholeWell.column_names.map {|c| c.upcase}
    @borehole_wells = BoreholeWell.all
    respond_to do |format|
      format.xlsx
    end
  end
end
