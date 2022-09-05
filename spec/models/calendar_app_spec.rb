require 'rails_helper'

RSpec.describe CalendarApp, type: :model do
  # This test only works in September 2022 since calendar would need to be updated.
  begin
    cal = CalendarApp.find(1)
  rescue
    cal = CalendarApp.create()
  ensure
    puts "\nIt must have correct and sorted month range:"
    it "must have correct and sorted month range" do
      for indx in 0..9 do # Run 10 times
        start_year = 2019
        end_year = 2025
        rand_month = rand(1..12)
        rand_year = rand(start_year..end_year)
        month_current = Time.current.month
        year_current = Time.current.year
        rand_x_axis = (rand_year-start_year)*12 + rand_month
        current_x_axis = (year_current-start_year)*12 + month_current
        x_axis_diff = rand_x_axis - current_x_axis
        if x_axis_diff == 0
          res_expected = "Current month"
        elsif x_axis_diff > 0 and x_axis_diff <= 6
          res_expected = "Next 6 months"
        elsif x_axis_diff > 6 and x_axis_diff <= 18
          res_expected = "Next year & 6 months"
        elsif x_axis_diff < 0 and x_axis_diff > -6
          res_expected = "Past 5 months"
        elsif x_axis_diff <= -6 and x_axis_diff > -18
          res_expected = "Past year and 5 months"
        else
          res_expected = "Not registered on calendar"
        end

        begin
          mon = MonthApp.find(rand_x_axis-27) # Skipping 27 months since 2019
          found_x_axis = (mon.current_year-start_year)*12 + mon.month
          found_x_axis_diff = found_x_axis - current_x_axis
          if found_x_axis_diff == 0
            res_found = "Current month"
          elsif found_x_axis_diff > 0 and found_x_axis_diff <= 6
            res_found = "Next 6 months"
          elsif found_x_axis_diff > 6 and found_x_axis_diff <= 18
            res_found = "Next year & 6 months"
          elsif found_x_axis_diff < 0 and found_x_axis_diff > -6
            res_found = "Past 5 months"
          elsif found_x_axis_diff <= -6 and found_x_axis_diff > -18
            res_found = "Past year and 5 months"
          else
            res_found = "ERROR: a month exists when it shouldn't. Has the calendar been updated?"
          end
        rescue ActiveRecord::RecordNotFound
          res_found = "Not registered on calendar"
        ensure
          puts ("TEST INDEX:" + indx.to_s)
          puts ("Random Month:" + rand_month.to_s + "/" + rand_year.to_s + " - Random X-Axis: " + rand_x_axis.to_s + " - X-Axis Difference: " + x_axis_diff.to_s)
          puts ("EXPECTED: " + res_expected)
          puts ("GOT: " + res_found + "\n")
          expect(res_found).to eq(res_expected)
        end
      
      end
    
    end

  end

end
