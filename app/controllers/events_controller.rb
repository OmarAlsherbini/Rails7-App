class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    
        

                


        


    respond_to do |format|
      if event_params[:start_date] >= event_params[:end_date]
        format.html { render :new, alert: "Error: End date must be greater than start date!", status: :bad_request }
        format.json { render json: { :errors => "Error: End date must be greater than start date!" }.to_json, status: :bad_request }
      end

      if @event.save
        if event_params[:event_type] == "1"
          # Check if user_id is inserted.
          if event_params[:user_id]
            host_user = User.find(event_params[:user_id])
            if host_user
              # Check event conflicts for the host user.
              all_host_events = UserEvent.where(user_id: event_params[:user_id])
              for host_event in all_host_events
                if !host_event.event.overwritable and ((host_event.event.start_date > event_params[:start_date] and host_event.event.start_date < event_params[:end_date]) or (host_event.event.end_date > event_params[:start_date] and host_event.event.end_date < event_params[:end_date]) or (host_event.event.start_date < event_params[:start_date] and host_event.event.end_date > event_params[:end_date]))
                  @event.delete
                  format.html { render :new, alert: "Error: A non-overwritable event already exists at that time for the host!", status: :bad_request }
                  format.json { render json: { :errors => "Error: A non-overwritable event already exists at that time for the host!" }.to_json, status: :bad_request }
                end
              end

              # Check event conflicts for the current user.
              all_current_user_events = UserEvent.where(user_id: current_user.id)
              for current_user_event in all_current_user_events
                if !current_user_event.event.overwritable and ((current_user_event.event.start_date > event_params[:start_date] and current_user_event.event.start_date < event_params[:end_date]) or (current_user_event.event.end_date > event_params[:start_date] and current_user_event.event.end_date < event_params[:end_date]) or (current_user_event.event.start_date < event_params[:start_date] and current_user_event.event.end_date > event_params[:end_date]))
                  @event.delete
                  format.html { render :new, alert: "Error: A non-overwritable event already exists at that time for the current user!", status: :bad_request }
                  format.json { render json: { :errors => "Error: A non-overwritable event already exists at that time for the current user!" }.to_json, status: :bad_request }
                end
              end

              @all_location = request.location.data
              # @user_country = request.location.country
              # @user_city = request.location.city
              # @user_country = @all_location["country"]
              # @user_city = @all_location["city"]
              @user_physical_address = request.location.address
              # @user_ip_address = request.location.ip
              # @user_ip_address = @all_location["ip"]
              @user_lat_long = @all_location["loc"]
              # @user_lat = request.location.lat
              # @user_long = request.location.long
              # @user_lat_long = request.location.data.loc
              # All clear! Now, create the event for the host user.
              current_user.physical_address = @user_physical_address
              current_user.lat_long = @user_lat_long
              current_user.save
              UserEvent.create(event_id: @event.id, user_id: event_params[:user_id], user_first_name: current_user.first_name, user_last_name: current_user.last_name, user_phone_number: current_user.phone_number, user_physical_address: current_user.physical_address, user_lat_long: current_user.lat_long)
              # Create the event for the current user.
              UserEvent.create(event_id: @event.id, user_id: current_user.id, user_first_name: host_user.first_name, user_last_name: host_user.last_name, user_phone_number: host_user.phone_number, user_physical_address: host_user.physical_address, user_lat_long: host_user.lat_long)
            else
              @event.delete
              format.html { render :new, alert: "Error: User does not exist!", status: :bad_request }
              format.json { render json: { :errors => "Error: User does not exist!" }.to_json, status: :bad_request }
              # flash.now[:notice] = 'Message sent!'
              # flash.now[:alert] = 'Error while sending message!'
              # format.html { redirect_to request.referer, :notice => 'Message sent!' }
            end
          else
            @event.delete
            format.html { render :new, alert: "Error: No user was selected for event type 1!", status: :bad_request }
            format.json { render json: { :errors => "Error: No user was selected for event type 1!" }.to_json, status: :bad_request }
          end
        end

        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Defined in routes.rb to get the events of a particular user by user_id
  def get_user_events
    @eventData = Event.call_from_controller(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:month_app_id, :user_id, :name, :all_day, :overwritable, :start_date, :end_date, :event_type, :event_details, :event_value)
    end
end
