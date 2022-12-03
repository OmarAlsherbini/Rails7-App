require 'rails_helper'

RSpec.describe CalendarApp, type: :model do
  # This test only works when there are no created test data ran from previous months existing in the test DB.
  # Please make sure to either delete previous calendar test data and start new ones!
  
  # Test parameters: customize as you please.
  
  n_tests = 50
  
  begin
    cal = CalendarApp.find(1)
  rescue
    cal = CalendarApp.create()
  ensure
    start_year = Time.current.year - 2*cal.n_yr_span
    end_year = Time.current.year + 2*cal.n_yr_span
    cal_n_mon_span = cal.n_mon_span
    cal_n_yr_span = cal.n_yr_span
    if cal.include_current_month_in_past
      cal_add_to_past = 1
    else
      cal_add_to_past = 0
    end
    future_months = cal_n_mon_span + 12*cal_n_yr_span
    past_months = cal_n_mon_span + 12*cal_n_yr_span - cal_add_to_past
    
    current_month = Time.current.month
    current_year = Time.current.year
    current_month_in_calendar = MonthApp.where(month: current_month, current_year: current_year)[0]
    
    
    # res_expected = []
    # res_got_in_calendar = []
    # res_got_not_in_calendar = []

    # Some arrays for the date puts
    random_months_in_cal_current = []
    random_years_in_cal_current = []
    random_months_in_cal_future = []
    random_years_in_cal_future = []
    random_months_in_cal_past = []
    random_years_in_cal_past = []
    random_months_not_in_cal = []
    random_years_not_in_cal = []

    # Expected results indices
    expected_current_idx = []
    expected_future_idx = []
    expected_past_idx = []
    expected_not_in_cal_idx = []

    # Test Results
    res_arr = []
    res_arr_meaning = [
                        "Current month",
                        "Next months",
                        "Past months",
                        "Not registered on calendar",
                        "ERROR: a month exists when it shouldn't. Has the calendar been updated?"
                      ]



    for indx in 0...n_tests do # Run n_tests times

      # Expectations for random month/year
      rand_month = rand(1..12)
      rand_year = rand(start_year..end_year)
      current_x_axis = (current_year-start_year)*12 + current_month
      rand_x_axis = (rand_year-start_year)*12 + rand_month
      x_axis_diff = rand_x_axis - current_x_axis
      if x_axis_diff == 0
        #res_expected.append("Current month")
        #res_expected = "Current month"
        random_months_in_cal_current.append(rand_month.to_s)
        random_years_in_cal_current.append(rand_year.to_s)
      elsif x_axis_diff > 0 and x_axis_diff <= future_months
        #res_expected.append("Next months")
        #res_expected = "Next months"
        random_months_in_cal_future.append(rand_month.to_s)
        random_years_in_cal_future.append(rand_year.to_s)
      elsif x_axis_diff < 0 and x_axis_diff >= -past_months
        #res_expected.append("Past months")
        #res_expected = "Past months"
        random_months_in_cal_past.append(rand_month.to_s)
        random_years_in_cal_past.append(rand_year.to_s)
      else
        #res_expected = "Not registered on calendar"
        random_months_not_in_cal.append(rand_month.to_s)
        random_years_not_in_cal.append(rand_year.to_s)
      end

      # Random Test
      begin
        #mon = MonthApp.find(rand_x_axis-27) # Skipping 27 months since 2019
        mon = MonthApp.where(month: rand_month.to_s, current_year: rand_year.to_s)[0]
        #found_x_axis = (mon.current_year-start_year)*12 + mon.month
        if mon.nil?
          res_arr.append(3)
        else
          found_x_axis_diff = mon.id - current_month_in_calendar.id
          # if mon.id == current_month_in_calendar.id
          # elsif mon.id > current_month_in_calendar.id and found_x_axis_diff <= future_months
          # elsif
          # else

          
          if found_x_axis_diff == 0
            #res_got_in_calendar.append("Current month")
            res_arr.append(0)
            
            #res_found = "Current month"
          elsif found_x_axis_diff > 0 and found_x_axis_diff <= future_months
            #res_got_in_calendar.append("Next months")
            res_arr.append(1)

            #res_found = "Next months"
          elsif found_x_axis_diff < 0 and found_x_axis_diff >= -past_months
            #res_got_in_calendar.append("Past months")
            res_arr.append(2)

            #res_found = "Past months"
          else
            #res_got_in_calendar.append("ERROR: a month exists when it shouldn't. Has the calendar been updated?")
            res_arr.append(4)
            #res_found = "ERROR: a month exists when it shouldn't. Has the calendar been updated?"
          end
        end
        
      rescue ActiveRecord::RecordNotFound
        #res_got_not_in_calendar.append("Not registered on calendar")
        res_arr.append(3)

        #res_found = "Not registered on calendar"
      # ensure
      #   puts ("TEST INDEX:" + indx.to_s)
      #   puts ("Random Month:" + rand_month.to_s + "/" + rand_year.to_s + " - Random X-Axis: " + rand_x_axis.to_s + " - X-Axis Difference: " + x_axis_diff.to_s)
      #   puts ("EXPECTED: " + res_expected)
      #   puts ("GOT: " + res_found + "\n")
      #   expect(res_found).to eq(res_expected)
      end
    
    end

    #puts "\n***** Current Month Calendar Tests: *****\n"

    #p "Random Current Months: #{random_months_in_cal_current}"
    #p "Random Current Years: #{random_years_in_cal_current}"
    
    for indx in 0...random_months_in_cal_current.length()
      #puts "\n#{indx+1}. it #{random_months_in_cal_current[indx]}/#{random_years_in_cal_current[indx]} must be the current month in the calendar."
      it "#{indx+1}. #{random_months_in_cal_current[indx]}/#{random_years_in_cal_current[indx]} must be the current month in the calendar. Result Array: #{res_arr[indx]}. Expected: #{res_arr_meaning[0]}. Got: #{res_arr_meaning[res_arr[indx]]}" do
        expect(res_arr_meaning[res_arr[indx]]).to eq(res_arr_meaning[0])
        #puts ("EXPECTED: " + res_arr_meaning[0])
        #puts ("GOT: " + res_arr_meaning[res_arr[indx]])
      end
    end

    #puts "\n***** Future Months Calendar Tests: *****\n"

    #p "Random Future Months: #{random_months_in_cal_future}"
    #p "Random Future Years: #{random_years_in_cal_future}"

    for indx in 0...random_months_in_cal_future.length()
      test_idx = indx+1+random_months_in_cal_current.length()
      #puts "\n#{test_idx}. it #{random_months_in_cal_future[indx]}/#{random_years_in_cal_future[indx]} must be a future month in the calendar."
      it "#{test_idx}. #{random_months_in_cal_future[indx]}/#{random_years_in_cal_future[indx]} must be a future month in the calendar. Result Array: #{res_arr[test_idx-1]}. Expected: #{res_arr_meaning[1]}. Got: #{res_arr_meaning[res_arr[test_idx-1]]}" do
        expect(res_arr_meaning[res_arr[test_idx-1]]).to eq(res_arr_meaning[1])
        #puts ("EXPECTED: " + res_arr_meaning[1])
        #puts ("GOT: " + res_arr_meaning[res_arr[test_idx-1]])
      end
    end

    #puts "\n***** Past Months Calendar Tests: *****\n"
    
    #p "Random Past Months: #{random_months_in_cal_past}"
    #p "Random Past Years: #{random_years_in_cal_past}"

    for indx in 0...random_months_in_cal_past.length()
      test_idx = indx+1+random_months_in_cal_current.length()+random_months_in_cal_future.length()
      #puts "\n#{test_idx}. it #{random_months_in_cal_past[indx]}/#{random_years_in_cal_past[indx]} must be a past month in the calendar."
      it "#{test_idx}. #{random_months_in_cal_past[indx]}/#{random_years_in_cal_past[indx]} must be a past month in the calendar. Result Array: #{res_arr[test_idx-1]}. Expected: #{res_arr_meaning[2]}. Got: #{res_arr_meaning[res_arr[test_idx-1]]}" do
        expect(res_arr_meaning[res_arr[test_idx-1]]).to eq(res_arr_meaning[2])
        #puts ("EXPECTED: " + res_arr_meaning[2])
        #puts ("GOT: " + res_arr_meaning[res_arr[test_idx-1]])
      end
    end
    
    
    #puts "\n***** Not in Calendar Tests: *****\n"
    
    #p "Random Not in Calendar Months: #{random_months_not_in_cal}"
    #p "Random Not in Calendar Years: #{random_years_not_in_cal}"
    
    for indx in 0...random_months_not_in_cal.length()
      test_idx = indx+1+random_months_in_cal_current.length()+random_months_in_cal_future.length()+random_months_in_cal_past.length()
      #puts "\n#{test_idx}. it #{random_months_not_in_cal[indx]}/#{random_years_not_in_cal[indx]} must not exist in the calendar."
      it "#{test_idx}. #{random_months_not_in_cal[indx]}/#{random_years_not_in_cal[indx]} must not exist in the calendar. Result Array: #{res_arr[test_idx-1]}. Expected: #{res_arr_meaning[3]}. Got: #{res_arr_meaning[res_arr[test_idx-1]]}" do
        expect(res_arr_meaning[res_arr[test_idx-1]]).to eq(res_arr_meaning[3])
        #puts ("EXPECTED: " + res_arr_meaning[3])
        #puts ("GOT: " + res_arr_meaning[res_arr[test_idx-1]])
      end
    end
    
    
    
    
    # puts "\nIt must have correct and sorted month range:"
    # it "must have correct and sorted month range" do
      
    
    # end

  end

  p "Resuluts Final: #{res_arr}"

end
