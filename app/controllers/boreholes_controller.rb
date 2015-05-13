class BoreholesController < ApplicationController
  before_action :set_borehole, only: [:show, :edit, :update, :destroy]

  # GET /boreholes
  # GET /boreholes.json
  def index
    scope =Borehole
    unless params[:borehole_eno].blank?
      scope=scope.where(eno:params[:borehole_eno])
    end
    unless params[:borehole_name].blank?
      scope=scope.where(Borehole.arel_table[:entityid].matches("%#{params[:borehole_name]}%"))
    end
    unless params[:auto_remediation].blank?
      scope=scope.joins(:handler).where(:handlers=>{:auto_remediation=>"#{params[:auto_remediation]}"})
    end
    unless params[:manual_remediation].blank?
      scope=scope.joins(:handler).where(:handlers=>{:manual_remediation=>"#{params[:manual_remediation]}"})
    end
    unless params[:or_status].blank?
      scope=scope.joins(:handler).where(:handlers=>{:or_status=>"#{params[:or_status]}"})
    end
    scope=scope.uniq.order(:entityid)
    
    
    if request.format =='html'
      @boreholes = scope.paginate(:page => params[:page], :per_page => 20)
    else
      @boreholes = scope.all
    end
  end

  # GET /boreholes/1
  # GET /boreholes/1.json
  def show
  end

  # GET /boreholes/new
  def new
    @borehole = Borehole.new
  end

  # GET /boreholes/1/edit
  def edit
  end

  # POST /boreholes
  # POST /boreholes.json
  def create
    @borehole = Borehole.new(borehole_params)

    respond_to do |format|
      if @borehole.save
        format.html { redirect_to @borehole, notice: 'Borehole was successfully created.' }
        format.json { render :show, status: :created, location: @borehole }
      else
        format.html { render :new }
        format.json { render json: @borehole.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boreholes/1
  # PATCH/PUT /boreholes/1.json
  def update
    respond_to do |format|
      if @borehole.update(borehole_params)
        format.html { redirect_to @borehole, notice: 'Borehole was successfully updated.' }
        format.json { render :show, status: :ok, location: @borehole }
      else
        format.html { render :edit }
        format.json { render json: @borehole.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boreholes/1
  # DELETE /boreholes/1.json
  def destroy
    @borehole.destroy
    respond_to do |format|
      format.html { redirect_to boreholes_url, notice: 'Borehole was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_borehole
      @borehole = Borehole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def borehole_params
      params[:borehole]
    end
end
