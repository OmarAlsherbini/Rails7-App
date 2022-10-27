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

    # Creates UserEvents for involved users in the event as well after checking request validity.
    form_no_errors = true
    respond_to do |format|
      if event_params[:start_date] >= event_params[:end_date]
        form_no_errors = false
        @event.errors.add(:end_date, message: "must be greater than start date!")
        
      elsif not MonthApp.exists?(event_params[:month_app_id])
        form_no_errors = false
        @event.errors.add(:month_app_id, message: "does not exist in Calendar!")
      
      else
        month_app = MonthApp.find(event_params[:month_app_id])

        if month_app.month != event_params[:start_date].to_datetime.month
          form_no_errors = false
          @event.errors.add(:month_app_id, message: ": Wrong month in calendar!")
        elsif month_app.current_year != event_params[:start_date].to_datetime.year
          form_no_errors = false
          @event.errors.add(:month_app_id, message: ": Wrong year in calendar!")
          
        elsif event_params[:event_type] == "1"
          
          # Check if user_id is inserted.
          if event_params.has_key?(:user_id)
            
            if not User.exists?(event_params[:user_id])
              
              form_no_errors = false
              @event.errors.add(:user_id, message: "does not exist!")
              
            elsif event_params[:user_id] == current_user.id.to_s
              
              form_no_errors = false
              @event.errors.add(:user_id, message: "is the same as the logged in user!")

            else
              host_user = User.find(event_params[:user_id])
              # Check event conflicts for the host user.
              all_host_events = UserEvent.where(user_id: event_params[:user_id])
              for host_event in all_host_events
                if Event.check_events_conflict(host_event.event.start_date, host_event.event.end_date, event_params[:start_date].to_datetime, event_params[:end_date].to_datetime, host_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  @event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the host!")
                  
                  
                end
              end

              # Check event conflicts for the current user.
              all_current_user_events = UserEvent.where(user_id: current_user.id)
              for current_user_event in all_current_user_events

                if Event.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, event_params[:start_date].to_datetime, event_params[:end_date].to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  @event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
                  
                end
              end
              if form_no_errors
                @event.save
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
              end
              
            end

          else
            form_no_errors = false
            @event.errors.add(:user_id, message: ": No user was selected for event type 1!")
            
            
          end
        elsif event_params[:event_type] == "0"
          # You can't allow a type 0 event to be overwritable!
          if event_params[:overwritable] == "1"
            form_no_errors = false
            @event.errors.add(:overwritable, message: ": Creating an overwritable type 0 event is not allowed!")
            
          end

          # Check event conflicts for the current user.
          all_current_user_events = UserEvent.where(user_id: current_user.id)
          for current_user_event in all_current_user_events
            if Event.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, event_params[:start_date].to_datetime, event_params[:end_date].to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
              form_no_errors = false
              @event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
              
            end
          end
          # Create the event for the current user.
          UserEvent.create(event_id: @event.id, user_id: current_user.id)
        else
          form_no_errors = false
          @event.errors.add(:event_type, message: ": Unidentified event type! Allowed types are 0 for blocked events and 1 for reserved events.")
          
        end
        
      end
      if form_no_errors

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
    form_no_errors = true
    respond_to do |format|
      
      if !event_params.has_key?(:start_date)
        form_no_errors = false
        @event.errors.add(:start_date, message: "must be specified!")
      
      elsif !event_params.has_key?(:end_date)
        form_no_errors = false
        @event.errors.add(:end_date, message: "must be specified!")
      
      elsif event_params[:start_date] >= event_params[:end_date]
        form_no_errors = false
        @event.errors.add(:end_date, message: "must be greater than start date!")
        
      elsif !event_params.has_key?(:month_app_id)
        form_no_errors = false
        @event.errors.add(:month_app_id, message: "must be specified!")
        
      elsif not MonthApp.exists?(event_params[:month_app_id])
        form_no_errors = false
        @event.errors.add(:month_app_id, message: "does not exist in Calendar!")
      
      else
        month_app = MonthApp.find(event_params[:month_app_id])

        if month_app.month != event_params[:start_date].to_datetime.month
          form_no_errors = false
          @event.errors.add(:month_app_id, message: ": Wrong month in calendar!")
        elsif month_app.current_year != event_params[:start_date].to_datetime.year
          form_no_errors = false
          @event.errors.add(:month_app_id, message: ": Wrong year in calendar!")
          
        elsif !event_params.has_key?(:event_type)
          form_no_errors = false
          @event.errors.add(:event_type, message: "must be specified!")
          
        elsif @event.event_type.to_s != event_params[:event_type]
          form_no_errors = false
          @event.errors.add(:event_type, message: ": Changing the event type is not allowed!")
        
        elsif event_params[:event_type] == "1"

          # Check if user_id is inserted.
          if event_params.has_key?(:user_id)
            
            if not User.exists?(event_params[:user_id])
              
              form_no_errors = false
              @event.errors.add(:user_id, message: "does not exist!")
              
            elsif event_params[:user_id] == current_user.id.to_s or UserEvent.where(event_id: @event.id, user_id: event_params[:user_id]) == []
              
              form_no_errors = false
              @event.errors.add(:user_id, message: ": Changing the host user is not allowed!")

            else
              host_user = User.find(event_params[:user_id])
              # Check event conflicts for the host user.
              all_host_events = UserEvent.where(user_id: event_params[:user_id])
              for host_event in all_host_events
                if host_event.event.id != @event.id and Event.check_events_conflict(host_event.event.start_date, host_event.event.end_date, event_params[:start_date].to_datetime, event_params[:end_date].to_datetime, host_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  @event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the host!")
                  
                end
              end

              # Check event conflicts for the current user.
              all_current_user_events = UserEvent.where(user_id: current_user.id)
              for current_user_event in all_current_user_events

                if current_user_event.event.id != @event.id and Event.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, event_params[:start_date].to_datetime, event_params[:end_date].to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  @event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
                  
                end
              end
              
            end

          else
            form_no_errors = false
            @event.errors.add(:user_id, message: ": No user was selected for event type 1!")
            
            
          end
        elsif event_params[:event_type] == "0"
          # You can't allow a type 0 event to be overwritable!
          if event_params[:overwritable] == "1"
            form_no_errors = false
            @event.errors.add(:overwritable, message: ": Creating an overwritable type 0 event is not allowed!")
            
          end

          # Check event conflicts for the current user.
          all_current_user_events = UserEvent.where(user_id: current_user.id)
          for current_user_event in all_current_user_events
            if current_user_event.event.id != @event.id and Event.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, event_params[:start_date].to_datetime, event_params[:end_date].to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
              form_no_errors = false
              @event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
              
            end
          end

        else
          form_no_errors = false
          @event.errors.add(:event_type, message: ": Unidentified event type! Allowed types are 0 for blocked events and 1 for reserved events.")
          
        end
        
      end
      if form_no_errors
        if @event.update(event_params)
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

  # Defined in routes.rb to get the events of a particular user by user_id
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
      params.require(:event).permit(:month_app_id, :user_id, :name, :all_day, :overwritable, :start_date, :end_date, :event_type, :event_details, :event_value)
    end
end