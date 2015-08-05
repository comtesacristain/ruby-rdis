class BoreholePorpermPicksController < ApplicationController
  def index
    klass =BoreholePorpermPick
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
