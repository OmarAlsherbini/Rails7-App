require 'rails_helper'

RSpec.describe Event, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  # Test Parameters
  n_users = 10
  n_user_events_min = 5
  n_user_events_max = 50
  t_event_factor_min = 1
  t_event_factor_max = 32
  month_range_next = 1
  day_range_next = 5


  # Probabilities
  all_day_chance_one_in = 10
  overwritable_chance_one_in = 10
  non_existant_user_chance_one_in = 20
  no_start_day_chance_one_in = 20
  no_end_day_chance_one_in = 20
  no_start_time_chance_one_in = 20
  no_end_time_chance_one_in = 20
  not_same_day_chance_one_in = 10
  end_before_start_chance_one_in = 20
  

  users_ids = []
  users_built = []

  # Initialize users
  for indx in 0...n_users
    rand_user = FactoryBot.build(:user)
    users_ids.append(rand_user[:id])
    users_built.append(rand_user)
  end

  # Initialize calendar
  begin
    cal = CalendarApp.find(1)
    puts "Calendar #1 initialized."
  rescue => e
    puts "CalendarApp exception: #{e}"
    cal = CalendarApp.create()
    puts "Calendar ##{cal[:id]} initialized."
  end
  current_month = Time.current.month
  current_year = Time.current.year
  current_month_in_calendar = MonthApp.where(month: current_month, current_year: current_year)[0]


  # puts users_ids

  # for indx in 0...n_users
  #   # r_user = User.find(users_ids[indx])
  #   r_user = users_built[indx]
  #   puts "User ##{users_ids[indx]}: #{r_user}"
  # end

  for indx_user in 0...n_users
    current_user = users_built[indx_user]
    n_user_events = rand(n_user_events_min..n_user_events_max)
    for indx_event in 0...n_user_events
      
      # Initializing event parameters
      event_params = {}
      


      # Dates & Times
      no_start_day_roll = rand(0...no_start_day_chance_one_in)
      no_end_day_roll = rand(0...no_end_day_chance_one_in)
      no_start_time_roll = rand(0...no_start_time_chance_one_in)
      no_end_time_roll = rand(0...no_end_time_chance_one_in)
      
      months_till_event = rand(0..month_range_next)
      event_month = (current_month + months_till_event - 1) % 12 + 1
      event_year = current_year + (current_month + months_till_event - 1)/12

      event_day = rand(1..28) # Avoid dealing with February, which already gets tested in spec/models/calendar_app_spec.rb
      event_duration_days = rand(0..day_range_next)
      event_end_day = [28, event_day + event_duration_days].max
      start_day = "#{event_year}-#{event_month}-#{event_day}"
      end_day = "#{event_year}-#{event_month}-#{event_end_day}"      
      
      event_timeslot = rand(0..95)
      event_duration_timeslots = rand(t_event_factor_min..t_event_factor_max)
      event_end_timeslot = [95, event_duration_timeslots + event_timeslot].max
      start_time = Event.timeslot_to_time_str(event_timeslot)
      end_time = Event.timeslot_to_time_str(event_end_timeslot)

      end_before_start_roll = rand(0...end_before_start_chance_one_in) 
      if (no_start_day_roll == end_before_start_chance_one_in-1) # Swap start and end times => Error guaranteed
        tmp_day = start_day
        start_day = end_day
        end_day = tmp_day
        tmp_time = start_time
        start_time = end_time
        end_time = tmp_time
        
      end

      if all_day == '1'
        start_time_reformatted = "00:00:00"
        end_time_reformatted = "23:59:59"
      else
        start_time_reformatted = self.reformat_time(start_time)
        end_time_reformatted = self.reformat_time(end_time)
      end

      start_date = "#{start_day}T#{start_time_reformatted}"
      end_date = "#{end_day}T#{end_time_reformatted}"
      event.start_date = start_date
      event.end_date = end_date
      if start_date.to_datetime >= end_date.to_datetime
        # Error start_day must be before end_day
      else
        
        # Proceed
      end
      


      
      


      # event_hour = event_timeslot / 4
      # event_minutes = (event_timeslot % 4) * 15

      # event_hour = (event_timeslot/4).to_i
      # event_minutes = (i%4)*15
      # if event_hour < 1
      #   am_pm = "AM"
      #   hour_str = "12"
      # elsif event_hour < 12
      #   am_pm = "AM"
      #   hour_str = hour.to_s
      # elsif event_hour == 12
      #   am_pm = "PM"
      #   hour_str = hour.to_s
      # else
      #   am_pm = "PM"
      #   hour_str = (event_hour-12).to_s
      # end
      # if event_minutes == 0
      #   minutes_str = "00"
      # else
      #   minutes_str = event_minutes.to_s
      # end
      # available_timeslots.append("#{hour_str}:#{minutes_str} #{am_pm}")
      # start_day = "#{event_year}-#{event_month}-#{event_day}"




      start_day = "#{event_year}-#{event_month}-#{event_day}"
      start_time = "#{}"

      
      

      # event_month = [current_month+rand(0..month_range_next), 12].max




      if (no_start_day_roll == no_start_day_chance_one_in-1)
        # Error start_day does not exist
      else
        event_params["start_day"] = start_day
      end
      if (no_end_day_roll == no_end_day_chance_one_in-1)
        # Error end_day does not exist
      else
        event_params["end_day"] = end_day
      end
      if (no_start_time_roll == no_start_time_chance_one_in-1)
        # Error start_time does not exist
      else
        event_params["start_time"] = start_time
      end
      if (no_end_time_roll == no_end_time_chance_one_in-1)
        # Error end_time does not exist
      else
        event_params["end_time"] = end_time
      end
      
        # Dates & Times exist! Proceed...




      end

      # Host User
      host_user = users_built[rand(0...n_users)]
      non_existing_user_roll = rand(0...non_existant_user_chance_one_in)
      if (non_existing_user_roll == non_existant_user_chance_one_in-1)
        non_existing_id = rand(991830..999532)
        # Error User does not exist
      elsif host_user[:id] == current_user[:id]
        # Error Same User
      else
        # User checked! Proceed...

      end



      all_day_roll = rand(0...all_day_chance_one_in)
      if (all_day_roll == all_day_chance_one_in-1)
        all_day = true
      else
        all_day = false
      end
      overwritable_roll = rand(0...overwritable_chance_one_in)
      if (overwritable_roll == overwritable_chance_one_in-1)
        overwritable = true
      else
        overwritable = false
      end

    end
  end

  

end
