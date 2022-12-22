require 'rails_helper'

RSpec.describe Event, type: :model do
  ### WARNING: ATTENTION!!!
  # Using this test will delete all test records for User, Event & UserEvent models.
  # If this is undesired, comment it below:

  # Delete all current users & events
  UserEvent.delete_all
  User.delete_all
  Event.delete_all

  # Test Parameters
  n_users = 10
  n_user_events_min = 5
  n_user_events_max = 30
  t_event_factor_min = 1
  t_event_factor_max = 32
  month_range_next = 1
  day_range_next = 5

  # Do you want to output some console?!
  debug = false

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
  no_month_app_chance_one_in = 20
  wrong_month_app_chance_one_in = 20
  wrong_year_chance_one_in = 40
  no_event_type_chance_one_in = 20
  wrong_event_type_chance_one_in = 20
  zero_event_type_chance_one_in = 5
  
  if debug
    probabilities = {
      "Chance of All Day Events is One in" => all_day_chance_one_in,
      "Chance of Overwritable Events is One in" => overwritable_chance_one_in,
      "Chance of No Start Day is One in" => no_start_day_chance_one_in,
      "Chance of No End Day is One in" => no_end_day_chance_one_in,
      "Chance of No Start Time is One in" => no_start_time_chance_one_in,
      "Chance of No End Time is One in" => no_end_time_chance_one_in,
      "Chance of End Date Before Start Date is One in" => end_before_start_chance_one_in,
      "Chance of Not Choosing a Month From the Calendar is One in" => no_month_app_chance_one_in,
      "Chance of Choosing the Wrong Month in the Calendar is One in" => wrong_month_app_chance_one_in,
      "Chance of Choosing the Wrong Year in the Calendar is One in" => wrong_year_chance_one_in,
      "Chance of No Event Type is One in" => no_event_type_chance_one_in,
      "Chance of Wrong Event Type is One in" => wrong_event_type_chance_one_in,
      "Chance of Zero Event Types (Blocked) is One in" => zero_event_type_chance_one_in,
      "Chance of Not Choosing an Existing User is One in" => non_existant_user_chance_one_in,
    }
    test_parameters = {
      "Number of Users" => n_users,
      "Min Number of Events per User" => n_user_events_min,
      "Max Number of Events per User" => n_user_events_max,
      "Min Same Day Event Timeslots Duration" => t_event_factor_min,
      "Max Same Day Event Timeslots Duration" => t_event_factor_max,
      "Range of Future Months" => month_range_next,
      "Range of Event Days for All Day Events" => day_range_next
    }
    puts "\nTest Parameters: #{test_parameters}"
    puts "\nProbabilities: #{probabilities}"
  end

  users_ids = []
  users_built = []

  # Initialize users
  n_seq = 141
  for indx in 0...n_users
    begin
      rand_user = FactoryBot.create(:user)
    rescue ActiveRecord::RecordInvalid
      rand_user = User.find_by(email: "test_user#{n_seq}@example.com")
    end
    users_ids.append(rand_user[:id])
    users_built.append(rand_user)
    n_seq = n_seq + 1
  end

  # Initialize calendar
  begin
    cal = CalendarApp.find(1)
    # Update if not updated:
    date_today = Time.current
    last_updated = cal.updated_at
    months_elapsed = (date_today.year - last_updated.year)*12 + (date_today.month - last_updated.month)    
    
    if months_elapsed > 0
      months_all = MonthApp.where(calendar_app_id: cal[:id]).order(:id)
      CalendarApp.update_cal(months_elapsed, months_all)
    end
    if debug
      puts "Calendar #1 initialized."
    end
  rescue => e
    if debug
      puts "CalendarApp exception: #{e}"
    end
    cal = CalendarApp.create()
    if debug
      puts "Calendar ##{cal[:id]} initialized."
    end
  end
  current_month = Time.current.month
  current_year = Time.current.year
  current_month_in_calendar = MonthApp.where(month: current_month, current_year: current_year)[0]

  # Test Results
  error_mes_arr_meaning = [
    "must be specified!",
    "must be specified!",
    "must be specified!",
    "must be specified!",
    "must be greater than start date!",
    "does not exist in Calendar!",
    ": Wrong month in calendar!",
    ": Wrong year in calendar!",
    "does not exist!",
    "is the same as the logged in user!",
    ": A non-overwritable event already exists at that time for the host!",
    ": A non-overwritable event already exists at that time for the current user!",
    ": No user was selected for event type 1!",
    ": Creating an overwritable type 0 event is not allowed!",
    ": Unidentified event type! Allowed types are 0 for blocked events and 1 for reserved events."
  ]
  error_attr_arr_meaning = [
    "start_day",
    "end_day",
    "start_time",
    "end_time",
    "end_date",
    "month_app_id",
    "month_app_id",
    "month_app_id",
    "user_id",
    "user_id",
    "start_date",
    "start_date",
    "user_id",
    "overwritable",
    "event_type"
  ]
  # Since for loops don't work in rails rspect tests: ( -_- )
  test_hash = {}

  test_idx = 0
  for indx_user in 0...n_users
    if debug
      puts "\n\n\n***\\|/*** User ##{indx_user+1} ***\\|/***\n\n\n"
    end
    current_user = users_built[indx_user]
    n_user_events = rand(n_user_events_min..n_user_events_max)
    for indx_event in 0...n_user_events
      if debug
        puts "\n\n**** Test ##{test_idx+1}: Event ##{indx_event+1} for User ##{indx_user+1} ****\n\n"
      end
      expected_errors = {}
      actual_errors = {}

      # Initializing event parameters
      event_params = {}
      form_no_error_expected = true
      
      # all_day bool
      all_day_roll = rand(0...all_day_chance_one_in)
      if (all_day_roll == all_day_chance_one_in-1)
        all_day = "1"
      else
        all_day = "0"
      end
      event_params[:all_day] = all_day

      # overwritable bool
      overwritable_roll = rand(0...overwritable_chance_one_in)
      if (overwritable_roll == overwritable_chance_one_in-1)
        overwritable = "1"
      else
        overwritable = "0"
      end
      event_params[:overwritable] = overwritable

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
      event_end_day = [28, event_day + event_duration_days].min
      start_day = "#{event_year}-#{event_month}-#{event_day}"
      end_day = "#{event_year}-#{event_month}-#{event_end_day}"      
      
      event_timeslot = rand(0...24*ENV['EVENT_MODULARITY'].to_i)
      event_duration_timeslots = rand(t_event_factor_min..t_event_factor_max)
      event_end_timeslot = [24*ENV['EVENT_MODULARITY'].to_i-1, event_duration_timeslots + event_timeslot].min
      start_time = Event.timeslot_to_time_str(event_timeslot, ENV['EVENT_MODULARITY'])
      end_time = Event.timeslot_to_time_str(event_end_timeslot, ENV['EVENT_MODULARITY'])

      end_before_start_roll = rand(0...end_before_start_chance_one_in) 
      if (end_before_start_roll == end_before_start_chance_one_in-1) # Swap start and end times => Error guaranteed
        tmp_day = start_day
        start_day = end_day
        end_day = tmp_day
        tmp_time = start_time
        start_time = end_time
        end_time = tmp_time
        
      end

      if (no_start_day_roll == no_start_day_chance_one_in-1)
        # Error start_day does not exist
        if form_no_error_expected
          expected_errors["0"] = 0
        end
        form_no_error_expected = false
        
        if debug
          puts "Expected Error: start_day does not exist"
        end
      else
        event_params[:start_day] = start_day
      end
      if (no_end_day_roll == no_end_day_chance_one_in-1)
        # Error end_day does not exist
        if form_no_error_expected
          expected_errors["1"] = 1
        end
        form_no_error_expected = false
        if debug
          puts "Expected Error: end_day does not exist"
        end
      else
        event_params[:end_day] = end_day
      end
      if (no_start_time_roll == no_start_time_chance_one_in-1)
        if all_day == "0"
          # Error start_time does not exist
          if form_no_error_expected
            expected_errors["2"] = 2
          end
          form_no_error_expected = false
          if debug
            puts "Expected Error: start_time does not exist"
          end
        end
      else
        event_params[:start_time] = start_time
      end
      if (no_end_time_roll == no_end_time_chance_one_in-1)
        if all_day == "0"
          # Error end_time does not exist
          if form_no_error_expected
            expected_errors["3"] = 3
          end
          form_no_error_expected = false
          if debug
            puts "Expected Error: end_time does not exist"
          end
        end
      else
        event_params[:end_time] = end_time
      end      
      # Dates & Times exist! Proceed...

      if all_day == '1'
      #if all_day
        start_time_reformatted = "00:00:00"
        end_time_reformatted = "23:59:59"
      else
        start_time_reformatted = Event.reformat_time(start_time)
        end_time_reformatted = Event.reformat_time(end_time)
      end

      start_date = "#{start_day}T#{start_time_reformatted}"
      end_date = "#{end_day}T#{end_time_reformatted}"

      if start_date.to_datetime >= end_date.to_datetime
        # Error start_day must be before end_day
        if form_no_error_expected
          expected_errors["4"] = 4
        end
        form_no_error_expected = false
        if debug
          puts "Expected Error: start_day must be before end_day"
        end
      else
        # Proceed

        # MonthApp
        no_month_app_roll = rand(0...no_month_app_chance_one_in)
        wrong_month_app_roll = rand(0...wrong_month_app_chance_one_in)
        wrong_year_roll = rand(0...wrong_year_chance_one_in)
        if (no_month_app_roll == no_month_app_chance_one_in-1)
          # Error MonthApp doesn't exist
          if form_no_error_expected
            expected_errors["5"] = 5
          end
          form_no_error_expected = false
          if debug
            puts "Expected Error: MonthApp doesn't exist"
          end
        elsif (wrong_month_app_roll == wrong_month_app_chance_one_in-1)
          # Error wrong month in the calendar
          if form_no_error_expected
            expected_errors["6"] = 6
          end
          form_no_error_expected = false
          if debug
            puts "Expected Error: wrong month in the calendar"
          end
          wrong_event_month = (event_month + rand(1..11) - 1) % 12 + 1
          event_month_app = MonthApp.where(month: wrong_event_month, current_year: event_year)[0]
          event_params[:month_app_id] = event_month_app[:id]
        elsif (wrong_year_roll == wrong_year_chance_one_in-1)
          # Error wrong year in the calendar
          if form_no_error_expected
            expected_errors["7"] = 7
          end
          form_no_error_expected = false
          if debug
            puts "Expected Error: wrong year in the calendar"
          end
          wrong_event_year = event_year + (-1)**rand(1..2) # Either add or subtract a year
          begin
            event_month_app = MonthApp.where(month: event_month, current_year: wrong_event_year)[0]
            event_params[:month_app_id] = event_month_app[:id]
          rescue => e
            if debug
              puts "Exception handled with trying to get a wrong year MonthApp: #{e}"
            end
            event_params[:month_app_id] = 99999
          end
        
        else
          # Proceed
          event_month_app = MonthApp.where(month: event_month, current_year: event_year)[0]
          event_params[:month_app_id] = event_month_app[:id]

          # Event Type
          no_event_type_roll = rand(0...no_event_type_chance_one_in)
          wrong_event_type_roll = rand(0...wrong_event_type_chance_one_in)
          zero_event_type_roll = rand(0...zero_event_type_chance_one_in)
          if (no_event_type_roll == no_event_type_chance_one_in-1)
            # Error Event Type doesn't exist
            if form_no_error_expected
              expected_errors["14"] = 14
            end
            form_no_error_expected = false
            if debug
              puts "Expected Error: Event Type doesn't exist"
            end
          elsif (wrong_event_type_roll == wrong_event_type_chance_one_in-1)
            # Error wrong event type must be 0 or 1
            if form_no_error_expected
              expected_errors["14"] = 14
            end
            form_no_error_expected = false
            if debug
              puts "Expected Error: wrong event type must be 0 or 1"
            end
            event_type = rand(2..10).to_s
            event_params[:event_type] = event_type
          elsif (zero_event_type_roll == zero_event_type_chance_one_in-1) 
            # Proceed with Event Type 0
            event_type = "0"
            event_params[:event_type] = event_type

            # You can't allow a type 0 event to be overwritable!
            if overwritable == "1"
              # Error no overwritable for event type 0
              if form_no_error_expected
                expected_errors["13"] = 13
              end
              form_no_error_expected = false
              if debug
                puts "Expected Error: no overwritable for event type 0"
              end
              
            end
    
            # Check event conflicts for the current user.
            all_current_user_events = UserEvent.where(user_id: current_user[:id])
            for current_user_event in all_current_user_events

              if Event.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, start_date.to_datetime, end_date.to_datetime, current_user_event.event.overwritable, overwritable == '1')
                # Error Current User Conflict
                if form_no_error_expected
                  expected_errors["11"] = 11
                end
                form_no_error_expected = false
                if debug
                  puts "Expected Error: Current User Conflict"
                end
                
              end
            end

          else
            # Proceed with Event Type 1
            event_type = "1"
            event_params[:event_type] = event_type

            # Host User
            host_user = users_built[rand(0...n_users)]
            non_existing_user_roll = rand(0...non_existant_user_chance_one_in)
            if (non_existing_user_roll == non_existant_user_chance_one_in-1)
              non_existing_id = rand(991830..999532)
              # Error User does not exist
              if form_no_error_expected
                expected_errors["12"] = 12
              end
              form_no_error_expected = false
              if debug
                puts "Expected Error: User does not exist"
              end
            elsif host_user[:id] == current_user[:id]
              # Error Same User
              if form_no_error_expected
                expected_errors["9"] = 9
              end
              form_no_error_expected = false
              if debug
                puts "Expected Error: Same User"
              end
              event_params[:user_id] = host_user[:id]
            else
              # User checked! Proceed...
              event_params[:user_id] = host_user[:id]

              # Check event conflicts for the host user.
              all_host_events = UserEvent.where(user_id: host_user[:id])
              for host_event in all_host_events
                if Event.check_events_conflict(host_event.event.start_date, host_event.event.end_date, start_date.to_datetime, end_date.to_datetime, host_event.event.overwritable, overwritable == '1')
                  # Error Host Conflict
                  if form_no_error_expected
                    expected_errors["10"] = 10
                  end
                  form_no_error_expected = false
                  if debug
                    puts "Expected Error: Host Conflict"
                  end
                  
                end
              end
  
              # Check event conflicts for the current user.
              all_current_user_events = UserEvent.where(user_id: current_user[:id])
              for current_user_event in all_current_user_events
  
                if Event.check_events_conflict(current_user_event.event.start_date, current_user_event.event.end_date, start_date.to_datetime, end_date.to_datetime, current_user_event.event.overwritable, overwritable == '1')
                  # Error Current User Conflict
                  if form_no_error_expected
                    expected_errors["11"] = 11
                  end
                  form_no_error_expected = false
                  if debug
                    puts "Expected Error: Current User Conflict"
                  end
                end
              end
            end
          end
        end        
      end
      
      # Now test the creation of the event
      test_idx = test_idx + 1
      event_params[:name] = "Test ##{test_idx}: Event ##{indx_event+1} Name for User ##{indx_user+1}"
      event_params[:event_details] = "Test ##{test_idx}: Event ##{indx_event+1} Details for User ##{indx_user+1}"
      event_params[:created_at] = Time.current
      event_params[:updated_at] = Time.current
      event_params[:event_value] = rand(0..10000) 
      event = Event.new(event_params)
      if debug
        
        rolls = {
          "all_day_roll" => all_day_roll,
          "overwritable_roll" => overwritable_roll,
          "no_start_day_roll" => no_start_day_roll,
          "no_end_day_roll" => no_end_day_roll,
          "no_start_time_roll" => no_start_time_roll,
          "no_end_time_roll" => no_end_time_roll,
          "end_before_start_roll" => end_before_start_roll,
          "no_month_app_roll" => no_month_app_roll,
          "wrong_month_app_roll" => wrong_month_app_roll,
          "wrong_year_roll" => wrong_year_roll,
          "no_event_type_roll" => no_event_type_roll,
          "wrong_event_type_roll" => wrong_event_type_roll,
          "zero_event_type_roll" => zero_event_type_roll,
          "non_existing_user_roll" => non_existing_user_roll
        }
        puts "\nRandom Rolls: #{rolls}"
        puts "Expected no errors: #{form_no_error_expected}"
      end
      form_no_error_actual = Event.event_create(event_params, event, current_user)
      if debug
        puts "Actual no errors: #{form_no_error_actual}"
        puts "\nEvent Params: #{event_params}"
        puts "\nEvent: #{event.inspect}"
        puts "\nEvent Errors: #{event.errors.inspect}"
      end
      if form_no_error_actual
        event.save
        if event_type == "1"
          host_user_event = UserEvent.create(event_id: event.id, user_id: event_params[:user_id], user_first_name: current_user[:first_name], user_last_name: current_user[:last_name], user_phone_number: current_user[:phone_number], user_physical_address: current_user[:physical_address], user_lat_long: current_user[:lat_long])
          if debug
            puts "Added UserEvent ##{host_user_event[:id]}"
          end
        end
          # Create the event for the current user.
        current_user_event = UserEvent.create(event_id: event.id, user_id: current_user[:id], user_first_name: nil, user_last_name: nil, user_phone_number: nil, user_physical_address: nil, user_lat_long: nil)
        if debug
          puts "Added UserEvent ##{current_user_event[:id]}"
        end
      end

      expected_str = "#{test_idx}@#{indx_user+1}@#{indx_event+1}@#{form_no_error_actual}"
      expected_errors.each do |exp_attr, exp_mess|
        expected_str = "#{expected_str}@#{exp_attr}@#{exp_mess}"
      end

      actual_str = "#{form_no_error_actual}"
      event.errors.messages.each do |error_attr, attr_messages|
        actual_str = "#{actual_str}@#{error_attr}@#{attr_messages[0]}"
      end

      test_hash[expected_str] = actual_str

    end
  end

  # Tests
  test_index = 0
  puts "\n******** Tests ********\n\n"
  test_hash.each do |key, result|
    key_arr = key.split('@')
    result_arr = result.split('@')
    if (key_arr.length > 4)
      # Unsuccessful Request
      p "Rspec Test ##{test_index}: Trial ##{key_arr[0]} - User ##{key_arr[1]}: Event ##{key_arr[2]}'s creation with incorrect #{error_attr_arr_meaning[key_arr[4].to_i]} must be unsuccessful. Got: #{result_arr[0]}."
      it "Rspec Test ##{test_index}: Trial ##{key_arr[0]} - User ##{key_arr[1]}: Event ##{key_arr[2]}'s creation with incorrect #{error_attr_arr_meaning[key_arr[4].to_i]} must be unsuccessful" do
        expect(result_arr[0]).to eq(key_arr[3])
      end

      p "Rspec Test ##{test_index+1}: Trial ##{key_arr[0]} - User ##{key_arr[1]}: Event ##{key_arr[2]}'s creation with incorrect #{error_attr_arr_meaning[key_arr[4].to_i]} must be with error message '#{error_attr_arr_meaning[key_arr[4].to_i]} #{error_mes_arr_meaning[key_arr[5].to_i]}'. Got: '#{result_arr[1]} #{result_arr[2]}'"
      it "Rspec Test ##{test_index+1}: Trial ##{key_arr[0]} - User ##{key_arr[1]}: Event ##{key_arr[2]}'s creation with incorrect #{error_attr_arr_meaning[key_arr[4].to_i]} must be with error message '#{error_attr_arr_meaning[key_arr[4].to_i]} #{error_mes_arr_meaning[key_arr[5].to_i]}'" do
        expect("#{result_arr[1]} #{result_arr[2]}").to eq("#{error_attr_arr_meaning[key_arr[4].to_i]} #{error_mes_arr_meaning[key_arr[5].to_i]}")
      end
      test_index = test_index + 2
    else
      # Successful Creation of an Event
      p "Rspec Test ##{test_index}: Trial ##{key_arr[0]} - User ##{key_arr[1]}: Event ##{key_arr[2]}'s creation with correct parameters must be successful. Got: no_errors: #{result_arr[0]}"
      it "Rspec Test ##{test_index}: Trial ##{key_arr[0]} - User ##{key_arr[1]}: Event ##{key_arr[2]}'s creation with correct parameters must be successful" do
        expect(result_arr[0]).to eq(key_arr[3])
      end
      test_index + 1
    end

  end
  
end
