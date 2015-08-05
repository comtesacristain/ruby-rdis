class BoreholePorpermTwosController < ApplicationController
  def index
    klass =BoreholePorpermTwo
    @columns = klass.column_names
    @records = klass.all
    respond_to do |format|
      format.xlsx
    end
  end
end
