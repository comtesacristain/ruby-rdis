class BoreholeStratigraphiesController < ApplicationController
  def index
    klass =BoreholeStratigraphy
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
