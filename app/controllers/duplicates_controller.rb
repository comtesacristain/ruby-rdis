class DuplicatesController < ApplicationController
  before_action :set_duplicate, only: [:show, :edit, :update, :destroy]

  # GET /duplicates
  # GET /duplicates.json
  def index
    scope = Duplicate
    unless params[:borehole_eno].blank?
      scope=scope.joins(:boreholes).where(:boreholes=>{:eno=>params[:borehole_eno]})
    end
    unless params[:borehole_name].blank?

      scope=scope.joins(:boreholes).where("boreholes.entityid like '%#{params[:borehole_name]}%'")

    end
    unless params[:has_remediation].blank?
      scope=scope.where(:has_remediation=>params[:has_remediation])
    end
    unless params[:or_status].blank?
      scope=scope.joins(:boreholes=>:handler).where(:handlers=>{:or_status=>"#{params[:or_status]}"})
    end
scope=scope.uniq
    if request.format =='html'
    @duplicates = scope.paginate(:page => params[:page], :per_page => 20)
else
    @duplicates = scope.all
end
        respond_to do |format|
      format.html
      format.xlsx
    end
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
    if duplicate_params[:qaed]=='Y'
      @duplicate.handlers.each do |handler|
        handler.manual_remediation = handler.auto_remediation 
        handler.manual_transfer = handler.auto_transfer
        handler.save
      end
    else
      if params["handlers_attributes"].map{|k,x| x["manual_remediation"]}.uniq.include?("")
      elsif duplicate_params[:qaed]=='N'
        @duplicate.handlers.update_all(:manual_remediation=>'NONE',:manual_transfer=>nil)
=begin
    puts duplicate_params
    if duplicate_params[:qaed]=='Y'
      @duplicate.boreholes.each do |b|
        handler=b.handler
        handler.manual_remediation=handler.auto_remediation 
        handler.manual_transfer=handler.auto_transfer
        handler.save
      end
  elsif duplicate_params[:qaed]=='N'
    @duplicate.boreholes.each do |b|
      handler=b.handler
      handler.manual_remediation="NONE"
      handler.manual_transfer=nil
      handler.save
    end
  else @duplicate.boreholes.each do |b|
      handler=b.handler
      handler.manual_remediation=nil
      handler.manual_transfer=nil
      handler.save
    end
  end
=end
    respond_to do |format|
      if @duplicate.update(duplicate_params[:qaed])
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
      params.require(:duplicate).permit(:qaed,handlers_attributes:[:id,:manual_remediation,:manual_transfer])
    end
end
