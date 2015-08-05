class BoreholeDirSurveyStationsController < ApplicationController
  def index
    klass = BoreholeDirSurveyStation
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
