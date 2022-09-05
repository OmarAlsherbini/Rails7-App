require 'rails_helper'

RSpec.describe MonthApp, type: :model do
  months_names_input = Array["March", "June", "December", "January", "February", "December", "November", "February", "September", "April"]
  months_input = Array[3, 6, 12, 1, 2, 12, 11, 2, 9, 4]
  years_input = Array[2023, 2020, 2022, 2018, 2026, 2024, 2017, 2024, 2022, 2025]

  days_expected_output = Array[31, 30, 31, 31, 28, 31, 30, 29, 30, 30]
  numSpace_expected_output = Array[3, 1, 4, 1, 0, 0, 3, 4, 4, 2]
  puts "\nIt must have correct days number:"
  it "must have correct days number" do
    for indx in 0..9 do
      mon = FactoryBot.build(:month_app, month: months_input[indx], current_year: years_input[indx], days: CalendarApp.calc_month_days(months_input[indx], years_input[indx]), numSpace: CalendarApp.calc_numSpace(months_input[indx], years_input[indx]))
      puts ("INDEX:" + indx.to_s)
      puts ("EXPECTED: " + days_expected_output[indx].to_s)
      puts ("GOT: " + mon.days.to_s + "\n")
      expect(mon.days).to eq(days_expected_output[indx])
    end
    
    
  end

  it "must have correct numSpace" do
    puts "\nIt must have correct numSpace:"
    for indx in 0..9 do
      mon = FactoryBot.build(:month_app, month: months_input[indx], current_year: years_input[indx], days: CalendarApp.calc_month_days(months_input[indx], years_input[indx]), numSpace: CalendarApp.calc_numSpace(months_input[indx], years_input[indx]))
      puts ("INDEX:" + indx.to_s)
      puts ("EXPECTED: " + numSpace_expected_output[indx].to_s)
      puts ("GOT: " + mon.numSpace.to_s + "\n")
      expect(mon.numSpace).to eq(numSpace_expected_output[indx])
    end
    
  end
  
end
