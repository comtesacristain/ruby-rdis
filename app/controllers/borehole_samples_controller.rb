class BoreholeSamplesController < ApplicationController
  def index
    klass =BoreholeSample
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
