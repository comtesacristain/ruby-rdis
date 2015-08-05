class BoreholeRemarkwsController < ApplicationController
  def index
    klass =BoreholeRemarkws
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
