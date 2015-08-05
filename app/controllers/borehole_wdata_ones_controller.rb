class BoreholeWdataOnesController < ApplicationController
  def index
    klass =BoreholeWdataOne
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
