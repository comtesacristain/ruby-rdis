class BoreholeDirSurveysController < ApplicationController
  def index
    klass = BoreholeDirSurvey
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
