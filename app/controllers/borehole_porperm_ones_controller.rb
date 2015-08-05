class BoreholePorpermOnesController < ApplicationController
  def index
    klass =BoreholePorpermOne
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
