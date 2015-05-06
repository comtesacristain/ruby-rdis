class DuplicatesController < ApplicationController
  before_action :set_duplicate, only: [:show, :edit, :update, :destroy]

  # GET /duplicates
  # GET /duplicates.json
  def index
    @duplicates = Duplicate.all
  end

  # GET /duplicates/1
  # GET /duplicates/1.json
  def show
  end

  # GET /duplicates/new
  def new
    @duplicate = Duplicate.new
  end

  # GET /duplicates/1/edit
  def edit
  end

  # POST /duplicates
  # POST /duplicates.json
  def create
    @duplicate = Duplicate.new(duplicate_params)

    respond_to do |format|
      if @duplicate.save
        format.html { redirect_to @duplicate, notice: 'Duplicate was successfully created.' }
        format.json { render :show, status: :created, location: @duplicate }
      else
        format.html { render :new }
        format.json { render json: @duplicate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /duplicates/1
  # PATCH/PUT /duplicates/1.json
  def update
    respond_to do |format|
      if @duplicate.update(duplicate_params)
        format.html { redirect_to @duplicate, notice: 'Duplicate was successfully updated.' }
        format.json { render :show, status: :ok, location: @duplicate }
      else
        format.html { render :edit }
        format.json { render json: @duplicate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /duplicates/1
  # DELETE /duplicates/1.json
  def destroy
    @duplicate.destroy
    respond_to do |format|
      format.html { redirect_to duplicates_url, notice: 'Duplicate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_duplicate
      @duplicate = Duplicate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def duplicate_params
      params[:duplicate]
    end
end