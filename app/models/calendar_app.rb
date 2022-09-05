class CalendarApp < ApplicationRecord
    has_many :month_app
    after_create :build_calendar

    private

    def build_calendar
        months_names = Array["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        date_today = Time.current
        # Creation of months need to be sorted by id and date simultaneously.
        # Next and Previous 17 months are determined by current month, whether you will need 2 years ahead or 2 years behind or exactly 1 ahead and 1 behind if current month is June. This assumes current month counts among the past 18 months as well!
        if date_today.month == 6
          # Previous Year  
          for month_idx in 1..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year-1), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year-1), current_year: date_today.year-1)
          end
          # Current Year
          for month_idx in 1..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year), current_year: date_today.year)
          end
          # Next Year
          for month_idx in 1..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year+1), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year+1), current_year: date_today.year+1)
          end
        elsif date_today.month > 6
          mth_diff = date_today.month - 6
          # Previous Year
          for month_idx in (mth_diff+1)..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year-1), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year-1), current_year: date_today.year-1)
          end 
          # Current Year
          for month_idx in 1..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year), current_year: date_today.year)
          end
          # Next Year
          for month_idx in 1..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year+1), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year+1), current_year: date_today.year+1)
          end
          # Next 2 Years
          for month_idx in 1..mth_diff
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year+2), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year+2), current_year: date_today.year+2)
          end
            
        else
          # Previous 2 Years
          mth_diff = 6 - date_today.month
          for month_idx in (12-mth_diff)..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year-2), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year-2), current_year: date_today.year-2)
          end
          # Previous Year
          for month_idx in 1..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year-1), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year-1), current_year: date_today.year-1)
          end
          # Current Year
          for month_idx in 1..12
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year), current_year: date_today.year)
          end
          # Next Year
          for month_idx in 1..(12-mth_diff)
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, date_today.year+1), numSpace:CalendarApp.calc_numSpace(month_idx, date_today.year+1), current_year: date_today.year+1)
          end
        end
    end

    def self.call_from_controller(cal_id, month_elapsed)
      date_today = Time.current
      months_all = MonthApp.where(calendar_app_id: cal_id).order(:id)
      
      

      if month_elapsed > 0
        self.update_cal(month_elapsed, months_all)
      end

      calendar_arr = Array.new
      for mon in months_all
        calendar_arr.append({
          "name" => mon.name,
          "month" => mon.month,
          "days" => mon.days,
          "numSpace" => mon.numSpace,
          "currentYear" => mon.current_year,
        })
      end

      return calendar_arr
    end

    def self.update_cal(month_elapsed, months_all)
      date_today = Time.current
      months_names = Array["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      for mon in months_all
        new_month = (mon.month + month_elapsed) % 12
        new_year = mon.current_year + ((mon.month + month_elapsed) / 12).to_i 
        mon.update(name: months_names[new_month-1], month:new_month, days: CalendarApp.calc_month_days(new_month, new_year), numSpace:CalendarApp.calc_numSpace(new_month, new_year), current_year: new_year, updated_at: date_today)
      end
      cal_obj = CalendarApp.find(months_all[0].calendar_app_id)
      cal_obj.update(updated_at: date_today)
      cal_obj.save()
    end

      def self.calc_month_days(month_index, month_year)
        month_days = Array[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if month_index != 2 or month_year % 4 != 0
          return month_days[month_index-1]
        else
          return 29
        end
      end
  
      def self.calc_numSpace(month_index, month_year)
        month_days = Array[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        month_mod_7 = Array[3, 0, 3, 2, 3, 2, 3, 3, 2, 3, 2, 3]
        year_current = Time.current.year
        month_current = Time.current.month
        day_current = Time.current.day
        wday_current = Time.current.wday
        # Assume calendar starts on Sunday
        numspace_current = ((wday_current+1) - (day_current % 7)) % 7
        if month_year == year_current
          if month_index == month_current
            return numspace_current
          elsif month_index > month_current
            # numspace_current + shift + 1 day shift of potential 29-day February
            return (numspace_current + month_mod_7[(month_current-1)..(month_index-2)].sum + CalendarApp.check_feb(month_index, month_current, month_year, year_current)) % 7
          else
            # numspace_current - shift + 1 day shift of potential 29-day February
            return (numspace_current - month_mod_7[(month_index-1)..(month_current-2)].sum - CalendarApp.check_feb(month_index, month_current, month_year, year_current)) % 7
          end
        
        elsif month_year > year_current
          overall_numspace_shift = 0
          for year_idx in year_current..month_year
            if year_idx == year_current
              overall_numspace_shift = overall_numspace_shift + month_mod_7[(month_current-1)..11].sum
            elsif year_idx == month_year
              if month_index > 1
                overall_numspace_shift = overall_numspace_shift + month_mod_7[0..(month_index-2)].sum
              end 
            else
              overall_numspace_shift = overall_numspace_shift + month_mod_7.sum
            end
          end
          return (numspace_current + overall_numspace_shift + CalendarApp.check_feb(month_index, month_current, month_year, year_current)) % 7
        
        else
          overall_numspace_shift = 0
          for year_idx in month_year..year_current
            if year_idx == month_year
              overall_numspace_shift = overall_numspace_shift + month_mod_7[(month_index-1)..11].sum
            elsif year_idx == year_current
              if month_current > 1
                overall_numspace_shift = overall_numspace_shift + month_mod_7[0..(month_current-2)].sum
              end 
            else
              overall_numspace_shift = overall_numspace_shift + month_mod_7.sum
            end
          end
          return (numspace_current - overall_numspace_shift - CalendarApp.check_feb(month_index, month_current, month_year, year_current)) % 7
  
        end
  
      end
  
      # Add 1 to numSpace if the calculation involve a 29-day February (Leap Year)
      def self.check_feb(month_index, month_current, month_year, year_current)
        if year_current == month_year
          if year_current % 4 != 0
            return 0
          elsif month_index > 2 and month_current > 2
            return 0
          elsif month_index <= 2 and month_current <= 2
            return 0
          else
            return 1
          end
        
        elsif month_year > year_current
          leap_add = 0
          for year_idx in year_current..month_year
            if year_idx % 4 == 0
              if year_idx > year_current
                if year_idx < month_year or month_index > 2
                  leap_add = leap_add + 1
                end
              elsif month_current <= 2
                leap_add = leap_add + 1
              end
            end
          end
          return leap_add
        
        else
          leap_add = 0
          for year_idx in month_year..year_current
            if year_idx % 4 == 0
              if year_idx > month_year
                if year_idx < year_current or month_current > 2
                  leap_add = leap_add + 1
                end
              elsif month_index <= 2
                leap_add = leap_add + 1
              end
            end
          end
          return leap_add
        end
  
      end

end
