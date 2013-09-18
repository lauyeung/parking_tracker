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

  # GET /registrations/new
  def new
    @last_registration_email = session[:last_registration_id] ? Registration.find_by_id(session[:last_registration_id]).email : ''
    @registration = Registration.new
  end

  # GET /registrations/1/edit
  def edit
  end


  def create
    @registration = Registration.new(registration_params)
    if @registration.park
      session[:last_registration_id] = @registration.id
      flash[:notice] = "Thanks for registering your car!"
      redirect_to "/registrations/#{@registration.id}"
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
