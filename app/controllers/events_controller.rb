class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # before_action do
  #   if !User.validate_jwt_cookie(cookies, current_user)
  #     respond_to do |format|
  #       format.html { redirect_to sign_in_url, notice: "You need to sign in or sign up before continuing." }
  #       format.json { render status: 401, json: { response: "Authentication failed: invalid or non-existing authentication token." } }
  #     end
  #   end
  # end
  

  # GET /events or /events.json
  def index
    # if !User.validate_jwt_cookie(cookies, current_user)
    #   respond_to do |format|
    #     format.html { redirect_to sign_in_url, notice: "You need to sign in to access the requested resources." }
    #     format.json { render :json, {"success": false, "message": "You need to sign in to access the requested resources."}, status: :unauthorized }
    #   end
    # end
    @events = Event.all
    @jwt_cookie = cookies.signed[:jwt]
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @timeslots_available = Event.get_available_timeslots
  end

  # GET /events/1/edit
  def edit
    @timeslots_available = Event.get_available_timeslots
  end

  # POST /events or /events.json
  def create
    # Creates UserEvents for involved users in the event as well after checking request validity.
    @timeslots_available = Event.get_available_timeslots
    @event = Event.new(event_params)
    
    respond_to do |format|
      form_no_errors = Event.event_create(event_params, @event, current_user)
      if form_no_errors
        @all_location = request.location.data
        @user_physical_address = request.location.address
        @user_lat_long = @all_location["loc"]
        current_user.physical_address = @user_physical_address
        current_user.lat_long = @user_lat_long
        current_user.save

        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :bad_request }
        format.json { render json: @event.errors, status: :bad_request }
      end
    end
    
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    # Creates UserEvents for involved users in the event as well after checking request validity.
    @timeslots_available = Event.get_available_timeslots    
    
    respond_to do |format|
      form_no_errors = Event.event_update(event_params, @event, current_user)
      if form_no_errors
        if @event.update(event_params)

          @all_location = request.location.data
          @user_physical_address = request.location.address
          @user_lat_long = @all_location["loc"]
          current_user.physical_address = @user_physical_address
          current_user.lat_long = @user_lat_long
          current_user.save

          format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
          format.json { render :show, status: :ok, location: @event }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit, status: :bad_request }
        format.json { render json: @event.errors, status: :bad_request }
      end
    end

  end

  # DELETE /events/1 or /events/1.json
  def destroy
    all_rel_user_events = UserEvent.where(event_id: @event.id)
    all_rel_user_events.delete_all
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /events/get_user_events/1 or /events/get_user_events/1.json. Defined in routes.rb to get the events of a particular user by user_id
  def get_user_events
    user_visited = User.find(params[:id])
    @userID = user_visited.id
    @firstName = user_visited.first_name
    @lastName = user_visited.last_name
    @user_events = UserEvent.where(user_id: params[:id])
    @eventData = Event.call_from_controller(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.    
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:month_app_id, :user_id, :name, :all_day, :overwritable, :start_date, :end_date, :start_day, :end_day, :start_time, :end_time, :event_type, :event_details, :event_value)
    end
end