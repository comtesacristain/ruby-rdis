class BoreholeMineralAttributesController < ApplicationController
  def index
    klass = BoreholeMineralAttribute
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
