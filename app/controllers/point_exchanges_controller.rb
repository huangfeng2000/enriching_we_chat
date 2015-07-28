class PointExchangesController < ApplicationController
  before_action :set_point_exchange, only: [:show, :edit, :update, :destroy]

  # GET /point_exchanges
  # GET /point_exchanges.json
  def index
    @point_exchanges = PointExchange.all
  end

  # GET /point_exchanges/1
  # GET /point_exchanges/1.json
  def show
  end

  # GET /point_exchanges/new
  def new
    @point_exchange = PointExchange.new
    @remain_point = Customer.find(customer_codes[0][1]).point
  end

  # # GET /point_exchanges/1/edit
  # def edit
  #   point_exchange = PointExchange.find(params[:id])
  #   @remain_point = point_exchange.customer.customer_point.point
  # end

  # POST /point_exchanges
  # POST /point_exchanges.json
  def create
    @point_exchange = PointExchange.new(point_exchange_params)

    @remain_point = Customer.find(point_exchange_params[:customer_id]).customer_point.point
    @customer_point = Customer.find(point_exchange_params[:customer_id]).customer_point
    @customer_point.point = @customer_point.point - point_exchange_params[:point].to_i

    respond_to do |format|
      if @point_exchange.save and @customer_point.save
        format.html { redirect_to @point_exchange, notice: 'Point exchange was successfully created.' }
        format.json { render action: 'show', status: :created, location: @point_exchange }
      else
        format.html { render action: 'new' }
        format.json { render json: @point_exchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /point_exchanges/1
  # # PATCH/PUT /point_exchanges/1.json
  # def update
  #   respond_to do |format|
  #     if @point_exchange.update(point_exchange_params)
  #       format.html { redirect_to @point_exchange, notice: 'Point exchange was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @point_exchange.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /point_exchanges/1
  # DELETE /point_exchanges/1.json
  def destroy
    @customer_point = @point_exchange.customer.customer_point
    @customer_point.point = @customer_point.point + @point_exchange.point
    @customer_point.save

    @point_exchange.destroy
    respond_to do |format|
      format.html { redirect_to point_exchanges_url }
      format.json { head :no_content }
    end
  end

  def show_remain_point
    @remain_point = Customer.find(params[:customer_id]).customer_point.point
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_point_exchange
      @point_exchange = PointExchange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def point_exchange_params
      params.require(:point_exchange).permit(:customer_id, :point, :coupon_id)
    end
end
