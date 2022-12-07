class Event < ApplicationRecord
  belongs_to :month_app
  has_many :user_event
  has_many :users, through: :user_event
  attr_accessor :user_id
  # after_create :create_user_event

  private

  # def create_user_event
  #   UserEvent.create(event_id: self.id, user_id: current_user.id, user_physical_address: @user_physical_address, user_lat_long: @user_lat_long)
  # end

  def self.event_create(event_params, event, current_user)
    form_no_errors = true
    if !event_params.has_key?(:start_day)
      form_no_errors = false
      event.errors.add(:start_day, message: "must be specified!")
    elsif !event_params.has_key?(:end_day)
      form_no_errors = false
      event.errors.add(:end_day, message: "must be specified!")
    elsif event_params[:all_day] != '1' and !event_params.has_key?(:start_time)
      form_no_errors = false
      event.errors.add(:start_time, message: "must be specified!")
    elsif event_params[:all_day] != '1' and !event_params.has_key?(:end_time)
      form_no_errors = false
      event.errors.add(:end_time, message: "must be specified!")
    else
      if event_params[:all_day] == '1'
        start_time_reformatted = "00:00:00"
        end_time_reformatted = "23:59:59"
      else
        start_time_reformatted = self.reformat_time(event_params[:start_time])
        end_time_reformatted = self.reformat_time(event_params[:end_time])
      end
      start_date = "#{event_params[:start_day]}T#{start_time_reformatted}"
      end_date = "#{event_params[:end_day]}T#{end_time_reformatted}"
      event.start_date = start_date
      event.end_date = end_date

      if start_date.to_datetime >= end_date.to_datetime
        form_no_errors = false
        event.errors.add(:end_date, message: "must be greater than start date!")
        
      elsif not MonthApp.exists?(event_params[:month_app_id])
        form_no_errors = false
        event.errors.add(:month_app_id, message: "does not exist in Calendar!")
      
      else
        month_app = MonthApp.find(event_params[:month_app_id])
  
        if month_app.month != start_date.to_datetime.month
          form_no_errors = false
          event.errors.add(:month_app_id, message: ": Wrong month in calendar!")
        elsif month_app.current_year != start_date.to_datetime.year
          form_no_errors = false
          event.errors.add(:month_app_id, message: ": Wrong year in calendar!")
          
        elsif event_params[:event_type] == "1"
          
          # Check if user_id is inserted.
          if event_params.has_key?(:user_id)
            
            if not User.exists?(event_params[:user_id])
              
              form_no_errors = false
              event.errors.add(:user_id, message: "does not exist!")
              
            elsif event_params[:user_id].to_s == current_user.id.to_s
              
              form_no_errors = false
              event.errors.add(:user_id, message: "is the same as the logged in user!")
  
            else
              host_user = User.find(event_params[:user_id])
              
              # Check event conflicts for the host user.
              all_host_events = UserEvent.where(user_id: event_params[:user_id])
              for host_event in all_host_events
                if self.check_events_conflict(host_event.event.start_date, host_event.event.end_date, start_date.to_datetime, end_date.to_datetime, host_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the host!")
                  
                  
                end
              end
  
              # Check event conflicts for the current user.
              all_current_user_events = UserEvent.where(user_id: current_user.id)
              for current_user_event in all_current_user_events
  
                if self.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, start_date.to_datetime, end_date.to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
                  
                end
              end
              
            end
  
          else
            form_no_errors = false
            event.errors.add(:user_id, message: ": No user was selected for event type 1!")
            
            
          end

        elsif event_params[:event_type] == "0"
          # You can't allow a type 0 event to be overwritable!
          if event_params[:overwritable] == "1"
            form_no_errors = false
            event.errors.add(:overwritable, message: ": Creating an overwritable type 0 event is not allowed!")
          end
  
          # Check event conflicts for the current user.
          all_current_user_events = UserEvent.where(user_id: current_user.id)
          for current_user_event in all_current_user_events
            if self.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, start_date.to_datetime, end_date.to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
              form_no_errors = false
              event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
              
            end
          end
          
        else
          form_no_errors = false
          event.errors.add(:event_type, message: ": Unidentified event type! Allowed types are 0 for blocked events and 1 for reserved events.")          
        end
        
      end
      if form_no_errors
        if event_params[:event_type] == "0"
          event.save
          # Create the event for the current user.
          UserEvent.create(event_id: event.id, user_id: current_user.id)
        else
          event.save
          UserEvent.create(event_id: event.id, user_id: event_params[:user_id], user_first_name: current_user.first_name, user_last_name: current_user.last_name, user_phone_number: current_user.phone_number, user_physical_address: current_user.physical_address, user_lat_long: current_user.lat_long)
          # Create the event for the current user.
          UserEvent.create(event_id: event.id, user_id: current_user.id, user_first_name: host_user.first_name, user_last_name: host_user.last_name, user_phone_number: host_user.phone_number, user_physical_address: host_user.physical_address, user_lat_long: host_user.lat_long)
        end

      end
      
    end
    return form_no_errors
  end

  def self.event_update(event_params, event, current_user)
    start_time_reformatted = self.reformat_time(event_params[:start_time])
    end_time_reformatted = self.reformat_time(event_params[:end_time])
    start_date = "#{event_params[:start_day]}T#{start_time_reformatted}"
    end_date = "#{event_params[:end_day]}T#{end_time_reformatted}"
    form_no_errors = true
    if !event_params.has_key?(:start_date)
      form_no_errors = false
      event.errors.add(:start_date, message: "must be specified!")
    elsif !event_params.has_key?(:end_date)
      form_no_errors = false
      event.errors.add(:end_date, message: "must be specified!")
    elsif event_params[:all_day] != '1' and !event_params.has_key?(:start_time)
      form_no_errors = false
      event.errors.add(:start_time, message: "must be specified!")
    elsif event_params[:all_day] != '1' and !event_params.has_key?(:end_time)
      form_no_errors = false
      event.errors.add(:end_time, message: "must be specified!")
    else

      if event_params[:all_day] == '1'
        start_time_reformatted = "00:00:00"
        end_time_reformatted = "23:59:59"
      else
        start_time_reformatted = self.reformat_time(event_params[:start_time])
        end_time_reformatted = self.reformat_time(event_params[:end_time])
      end
      start_date = "#{event_params[:start_day]}T#{start_time_reformatted}"
      end_date = "#{event_params[:end_day]}T#{end_time_reformatted}"
      event.start_date = start_date
      event.end_date = end_date

      if start_date.to_datetime >= end_date.to_datetime
        form_no_errors = false
        event.errors.add(:end_date, message: "must be greater than start date!")
        
      elsif !event_params.has_key?(:month_app_id)
        form_no_errors = false
        event.errors.add(:month_app_id, message: "must be specified!")
        
      elsif not MonthApp.exists?(event_params[:month_app_id])
        form_no_errors = false
        event.errors.add(:month_app_id, message: "does not exist in Calendar!")
      
      else
        month_app = MonthApp.find(event_params[:month_app_id])
  
        if month_app.month != start_date.to_datetime.month
          form_no_errors = false
          event.errors.add(:month_app_id, message: ": Wrong month in calendar!")
        elsif month_app.current_year != start_date.to_datetime.year
          form_no_errors = false
          event.errors.add(:month_app_id, message: ": Wrong year in calendar!")
          
        elsif !event_params.has_key?(:event_type)
          form_no_errors = false
          event.errors.add(:event_type, message: "must be specified!")
          
        elsif event.event_type.to_s != event_params[:event_type]
          form_no_errors = false
          event.errors.add(:event_type, message: ": Changing the event type is not allowed!")
        
        elsif event_params[:event_type] == "1"
  
          # Check if user_id is inserted.
          if event_params.has_key?(:user_id)
            
            if not User.exists?(event_params[:user_id])
              
              form_no_errors = false
              event.errors.add(:user_id, message: "does not exist!")
              
            elsif event_params[:user_id] == current_user.id.to_s or UserEvent.where(event_id: event.id, user_id: event_params[:user_id]) == []
              
              form_no_errors = false
              event.errors.add(:user_id, message: ": Changing the host user is not allowed!")
  
            else
              host_user = User.find(event_params[:user_id])
              # Check event conflicts for the host user.
              all_host_events = UserEvent.where(user_id: event_params[:user_id])
              for host_event in all_host_events
                if host_event.event.id != event.id and self.check_events_conflict(host_event.event.start_date, host_event.event.end_date, start_date.to_datetime, end_date.to_datetime, host_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the host!")
                  
                end
              end
  
              # Check event conflicts for the current user.
              all_current_user_events = UserEvent.where(user_id: current_user.id)
              for current_user_event in all_current_user_events
  
                if current_user_event.event.id != event.id and self.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, start_date.to_datetime, end_date.to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
                  form_no_errors = false
                  event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
                  
                end
              end
              
            end
  
          else
            form_no_errors = false
            event.errors.add(:user_id, message: ": No user was selected for event type 1!")
            
            
          end
        elsif event_params[:event_type] == "0"
          # You can't allow a type 0 event to be overwritable!
          if event_params[:overwritable] == "1"
            form_no_errors = false
            event.errors.add(:event_type, message: ": Creating an overwritable type 0 event is not allowed!")
            
          end
  
          # Check event conflicts for the current user.
          all_current_user_events = UserEvent.where(user_id: current_user.id)
          for current_user_event in all_current_user_events
            if current_user_event.event.id != event.id and self.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, start_date.to_datetime, end_date.to_datetime, current_user_event.event.overwritable, event_params[:overwritable] == '1')
              form_no_errors = false
              event.errors.add(:start_date, message: ": A non-overwritable event already exists at that time for the current user!")
              
            end
          end
  
        else
          form_no_errors = false
          event.errors.add(:event_type, message: ": Unidentified event type! Allowed types are 0 for blocked events and 1 for reserved events.")
          
        end
        
      end

    end
    
    
    return form_no_errors
  end

  def self.call_from_controller(user_id)
    user_events_all = UserEvent.where(user_id: user_id).order(:id)
    eventData= Array.new
    for user_event in user_events_all
      eventData.append({
        "startDate" => user_event.event.start_date,
        "endDate" => user_event.event.end_date,
        "eventType" => user_event.event.event_type,
        "eventDetails" => user_event.event.event_details,
        "userFirstName" => user_event.user_first_name,
        "userLastName" => user_event.user_last_name,
        "userPhoneNumber" => user_event.user_phone_number,
        "userPhysicalAddress" => user_event.user_physical_address,
        "userLatLong" => user_event.user_lat_long,
        "userPerformance" => user_event.user_performance,
        "eventValue" => user_event.event.event_value,
      })
    end
    return eventData
  end

  def self.check_events_conflict(old_start_date, old_end_date, new_start_date, new_end_date, old_overwritable, new_overwritable)
    if !old_overwritable and !new_overwritable and ((old_start_date > new_start_date and old_start_date < new_end_date) or (old_end_date > new_start_date and old_end_date < new_end_date) or (old_start_date < new_start_date and old_end_date > new_end_date) or (old_start_date > new_start_date and old_end_date < new_end_date))
      return true
    else
      return false
    end
  end


  def self.get_available_timeslots
    available_timeslots = ["Select Timeslot"]
    for i in 0..95 do
      #time_str_arr = self.timeslot_to_time(i)
      available_timeslots.append(self.timeslot_to_time_str(i))
      #available_timeslots.append("#{time_str_arr[0]}:#{time_str_arr[1]} #{time_str_arr[2]}")
      #available_timeslots.append("#{hour_str}:#{minutes_str} #{am_pm}")
    end
    p "Available Timeslots: #{available_timeslots}"
    return available_timeslots
  end

  def self.timeslot_to_time_str(timeslot)
    hour = (timeslot/4).to_i
    minutes = (timeslot%4)*15
    if hour < 1
      am_pm = "AM"
      hour_str = "12"
    elsif hour < 12
      am_pm = "AM"
      hour_str = hour.to_s
    elsif hour == 12
      am_pm = "PM"
      hour_str = hour.to_s
    else
      am_pm = "PM"
      hour_str = (hour-12).to_s
    end
    if minutes == 0
      minutes_str = "00"
    else
      minutes_str = minutes.to_s
    end
    return "#{hour_str}:#{minutes_str} #{am_pm}"
    #return [hour_str, minutes_str, am_pm]
  end

  def self.reformat_time(event_time)
    space_arr = event_time.split(' ', 2)
    col_arr = space_arr[0].split(':', 2)
    if event_time.split(' ', 2)[1] == 'AM'
      if(col_arr[0] == "12")
        reformatted_hour = "00"
      else
        reformatted_hour = col_arr[0]
      end
    else
      if(col_arr[0] == "12")
        reformatted_hour = col_arr[0]
      else
        reformatted_hour = (col_arr[0].to_i + 12).to_s
      end
    end
    return "#{reformatted_hour}:#{col_arr[1]}:00"
  end


end