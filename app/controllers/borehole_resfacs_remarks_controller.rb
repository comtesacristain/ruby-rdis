class BoreholeResfacsRemarksController < ApplicationController
  def index
    klass =BoreholeResfacsRemark
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
