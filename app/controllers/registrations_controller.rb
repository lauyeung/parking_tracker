class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.all
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  def history
    @registration = Registration.find(params[:id])
  end

  # GET /registrations/new
  def new
    @last_registration_email = session[:last_registration_id] ? Registration.find_by_id(session[:last_registration_id]).email : ''
    @last_registration_parking_spot_number = session[:last_registration_id] ? Registration.find_by_id(session[:last_registration_id]).parking_spot_number : ''
    @registration = Registration.new


    # The implementation above works.
    # The section below is how Dan implemented 'remember email' feature
    #
    # @last_registration = ParkingRegistration.find_by_id(session[:last_registration_id])
    # @parking_registration = ParkingRegistration.new
    #
    # @parking_registration.email = @last_registration.try(:email)
    ## above line is similar to what's below
    ## if @last_registration.present?
    ##   @parking_registration.email = @last_registration.email
    ## end
  end

  # GET /registrations/1/edit
  def edit
  end


  def create
    @registration = Registration.new(registration_params)
    if @registration.park
      session[:last_registration_id] = @registration.id
      flash[:notice] = "Thanks for registering your car!"
      redirect_to @registration
    else
      render :new
    end
  end

    # POST /responses
  # POST /responses.json
  # def create
  #   @registration = Registration.new(registration_params)

  #   respond_to do |format|
  #     if @registration.save
  #       format.html { redirect_to @registration, notice: 'Thanks for your feedback!' }
  #       format.json { render action: '/', status: :created, location: @registration }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @registration.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end



  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :email, :parking_spot_number)
    end
end
