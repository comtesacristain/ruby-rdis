class BoreholeWdataTwosController < ApplicationController
  def index
    klass =BoreholeWdataTwo
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
