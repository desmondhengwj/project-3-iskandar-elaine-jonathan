class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :owner? , only: [:edit, :destroy]
  before_action :authenticate_user!, only: [:index, :show, :new, :edit, :create, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    @request = Request.all
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
    @event = Event.all
  end

  # GET /requests/1/edit
  def edit

  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    @request.requestor_id = current_user.id
    @request.status = 'new'

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        # if @request.status != 'completed'
          format.html { redirect_to @request, notice: 'Request was successfully updated.' }
          format.json { render :show, status: :ok, location: @request }
        # else
        #   format.html { redirect_to controller:'orders', action: 'new', id:@request.id, cost:@request.cost }
        #   format.json { render :show, status: :ok, location: @request }
        # end
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /requests_status/1
  # PATCH/PUT /requests_status/1.json
  # def updateStatus
  #   @request = Request.new(status_params)
  #   respond_to do |format|
  #     if @request.update()
  #       format.html { redirect_to @request, notice: 'Request was successfully updated.' }
  #       format.json { render :index, status: :ok, location: @request }
  #     else
  #       format.html { render :index }
  #       format.json { render json: @request.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:requestor_id, :event_id, :description, :image_url, :cost, :delivery_arrangement, :status, :standin_id)
    end

    def owner?
        if @request.requestor_id != current_user.id
        redirect_to :events, :alert => "Hi there, it seems that you might be lost!"
        if !current_user
        redirect_to :new_user_registration, :notice => "Hi there, we invite you to sign up with us"
      end
    end
  end
end
