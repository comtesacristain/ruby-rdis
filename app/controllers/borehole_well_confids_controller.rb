class BoreholeWellConfidsController < ApplicationController
  def index
    klass =BoreholeWellConfid
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
