class DuplicateGroupsController < ApplicationController
  before_action :set_duplicate_group, only: [:show, :edit, :update, :destroy]

  # GET /duplicate_groups
  # GET /duplicate_groups.json
  def index
    @duplicate_groups = DuplicateGroup.all
  end

  # GET /duplicate_groups/1
  # GET /duplicate_groups/1.json
  def show
  end

  # GET /duplicate_groups/new
  def new
    @duplicate_group = DuplicateGroup.new
  end

  # GET /duplicate_groups/1/edit
  def edit
  end

  # POST /duplicate_groups
  # POST /duplicate_groups.json
  def create
    @duplicate_group = DuplicateGroup.new(duplicate_group_params)

    respond_to do |format|
      if @duplicate_group.save
        format.html { redirect_to @duplicate_group, notice: 'Duplicate group was successfully created.' }
        format.json { render :show, status: :created, location: @duplicate_group }
      else
        format.html { render :new }
        format.json { render json: @duplicate_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /duplicate_groups/1
  # PATCH/PUT /duplicate_groups/1.json
  def update
    respond_to do |format|
      if @duplicate_group.update(duplicate_group_params)
        format.html { redirect_to @duplicate_group, notice: 'Duplicate group was successfully updated.' }
        format.json { render :show, status: :ok, location: @duplicate_group }
      else
        format.html { render :edit }
        format.json { render json: @duplicate_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /duplicate_groups/1
  # DELETE /duplicate_groups/1.json
  def destroy
    @duplicate_group.destroy
    respond_to do |format|
      format.html { redirect_to duplicate_groups_url, notice: 'Duplicate group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_duplicate_group
      @duplicate_group = DuplicateGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def duplicate_group_params
      params[:duplicate_group]
    end
end
