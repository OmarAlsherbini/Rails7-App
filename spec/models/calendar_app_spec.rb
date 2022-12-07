require 'rails_helper'

RSpec.describe CalendarApp, type: :model do
  # This test only works when there are no created test data ran from previous months existing in the test DB.
  # Please make sure to either delete previous calendar test data and start new ones!
  
  # Test parameters: customize as you please.
  # n_test, start_year, end_year
  
  n_tests = 250
  
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

    # Test Results
    res_arr_meaning = [
                        "current month",
                        "next month",
                        "past month",
                        "not registered month",
                        "ERROR: a month exists when it shouldn't. Has the calendar been updated?"
                      ]
    # Since for loops don't work in rails rspect tests: ( -_- )
    test_hash = {}


    for indx in 0...n_tests do # Run n_tests times
      rand_month = rand(1..12)
      rand_year = rand(start_year..end_year)
      rand_date = "#{rand_month.to_s}/#{rand_year.to_s}"
      current_x_axis = (current_year-start_year)*12 + current_month
      rand_x_axis = (rand_year-start_year)*12 + rand_month
      x_axis_diff = rand_x_axis - current_x_axis

      # Expectations for random month/year:
      # expected_str = {test_index}_{random_month}/{random_ year}_{expected_value}
      # e.g. expected_str = 42_1/2023_1, where 1 as an expected value can be read as
      # res_arr_meaning[1] = "future month" (as of 30/11/2022).
      if x_axis_diff == 0
        expected_str = "#{indx+1}_#{rand_date}_0"
      elsif x_axis_diff > 0 and x_axis_diff <= future_months
        expected_str = "#{indx+1}_#{rand_date}_1"
      elsif x_axis_diff < 0 and x_axis_diff >= -past_months
        expected_str = "#{indx+1}_#{rand_date}_2"
      else
        expected_str = "#{indx+1}_#{rand_date}_3"
      end

      # Random Test
      begin
        mon = MonthApp.where(month: rand_month.to_s, current_year: rand_year.to_s)[0]
        if mon.nil?
          test_hash[expected_str] = 3
        else
          found_x_axis_diff = mon.id - current_month_in_calendar.id          
          if found_x_axis_diff == 0
            test_hash[expected_str] = 0
          elsif found_x_axis_diff > 0 and found_x_axis_diff <= future_months
            test_hash[expected_str] = 1
          elsif found_x_axis_diff < 0 and found_x_axis_diff >= -past_months
            test_hash[expected_str] = 2
          else
            test_hash[expected_str] = 4
          end
        end     
      rescue ActiveRecord::RecordNotFound
        test_hash[expected_str] = 3
      end
    end

    # Tests
    test_hash.each do |key, result|
      key_arr = key.split('_')
      p "#{key_arr[0]}. #{key_arr[1]} must be a #{res_arr_meaning[key_arr[2].to_i]} in the calendar. Got: #{res_arr_meaning[result]}"
      it "#{key_arr[0]}. #{key_arr[1]} must be a #{res_arr_meaning[key_arr[2].to_i]} in the calendar. Got: #{res_arr_meaning[result]}" do
        expect(res_arr_meaning[result]).to eq(res_arr_meaning[key_arr[2].to_i])
      end
    end
  end
end