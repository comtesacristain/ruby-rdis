class BoreholeResultwsController < ApplicationController
  def index
    klass =BoreholeResultws
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
