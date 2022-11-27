class CalendarAppsController < ApplicationController
  before_action :set_calendar_app, only: %i[ show edit update destroy ]
  before_action :call_calendar, only: [:show]
  before_action :authenticate_user!

  # GET /calendar_apps or /calendar_apps.json
  def index
    @calendar_apps = CalendarApp.all
    
    if current_user
      @all_location = request.location.data
      # @user_country = request.location.country
      # @user_city = request.location.city
      @user_country = @all_location["country"]
      @user_city = @all_location["city"]
      @user_physical_address = request.location.address
      # @user_ip_address = request.location.ip
      @user_ip_address = @all_location["ip"]
      @user_lat_long = @all_location["loc"]
      p "WWWWTTTTTTTTTTTTTTTYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY!!!!"
      puts "WARDEN TOKEN: #{request.env['warden-jwt_auth.token']}"
      #@user = get_user_from_token
    end
    
    # @user_lat = request.location.lat
    # @user_long = request.location.long
    # @user_lat_long = request.location.data.loc
  end

  # GET /calendar_apps/1 or /calendar_apps/1.json
  def show
  end

  # GET /calendar_apps/new
  def new
    @calendar_app = CalendarApp.new
  end

  # GET /calendar_apps/1/edit
  def edit
  end

  # POST /calendar_apps or /calendar_apps.json
  def create
    @calendar_app = CalendarApp.new(calendar_app_params)

    respond_to do |format|
      if @calendar_app.save
        format.html { redirect_to calendar_app_url(@calendar_app), notice: "Calendar app was successfully created." }
        format.json { render :show, status: :created, location: @calendar_app }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @calendar_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendar_apps/1 or /calendar_apps/1.json
  def update
    respond_to do |format|
      if @calendar_app.update(calendar_app_params)
        format.html { redirect_to calendar_app_url(@calendar_app), notice: "Calendar app was successfully updated." }
        format.json { render :show, status: :ok, location: @calendar_app }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @calendar_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendar_apps/1 or /calendar_apps/1.json
  def destroy
    @calendar_app.destroy

    respond_to do |format|
      format.html { redirect_to calendar_apps_url, notice: "Calendar app was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def location
    if params[:location].blank?
      if Rails.env.test? || Rails.env.development?
        @location ||= Geocoder.search("50.78.167.161").first
      else
        @location ||= request.location
      end
    else
      params[:location].each {|l| l = l.to_i } if params[:location].is_a? Array
      @location ||= Geocoder.search(params[:location]).first
      @location
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_app
      @calendar_app = CalendarApp.find(params[:id])
    end

    def call_calendar
      cal_object = CalendarApp.find(params[:id])
      date_today = Time.current
      @created_datetime = cal_object.created_at
      @last_updated = cal_object.updated_at
      @month_elapsed = ((date_today - @last_updated)/60/60/24/30).to_i
      @calendar = CalendarApp.call_from_controller(params[:id], @month_elapsed)
    end

    # Only allow a list of trusted parameters through.
    def calendar_app_params
      #params.fetch(:calendar_app, {})
      params.require(:calendar_app).permit(:n_mon_span, :n_yr_span, :include_current_month_in_past)
    end

    # def get_user_from_token
    #   jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
    #                            Rails.application.credentials.devise[:jwt_secret_key]).first
    #   user_id = jwt_payload['sub']
    #   User.find(user_id.to_s)
    # end
end

