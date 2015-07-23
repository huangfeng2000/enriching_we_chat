class CustomerPointsController < ApplicationController
  before_action :set_customer_point, only: [:show, :edit, :update, :destroy]

  # GET /customer_points
  # GET /customer_points.json
  def index
    @customer_points = CustomerPoint.all
  end

  # GET /customer_points/1
  # GET /customer_points/1.json
  def show
  end

  # GET /customer_points/new
  def new
    @customer_point = CustomerPoint.new
  end

  # GET /customer_points/1/edit
  def edit
  end

  # POST /customer_points
  # POST /customer_points.json
  def create
    @customer_point = CustomerPoint.new(customer_point_params)

    respond_to do |format|
      if @customer_point.save
        format.html { redirect_to @customer_point, notice: 'Customer point was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer_point }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_points/1
  # PATCH/PUT /customer_points/1.json
  def update
    respond_to do |format|
      if @customer_point.update(customer_point_params)
        format.html { redirect_to @customer_point, notice: 'Customer point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_points/1
  # DELETE /customer_points/1.json
  def destroy
    @customer_point.destroy
    respond_to do |format|
      format.html { redirect_to customer_points_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_point
      @customer_point = CustomerPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_point_params
      params.require(:customer_point).permit(:customer_id, :point, :comment)
    end
end
