class CalendarApp < ApplicationRecord
    has_many :month_app
    after_create :build_calendar

    private

    def build_calendar
        months_names = Array["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        date_today = Time.current
        n_mon = self.n_mon_span
        n_yr = self.n_yr_span
        is_included = self.include_current_month_in_past
        # To start from 1 not 0, you sub 1 and add 1
        mon_start_idx = (date_today.month - n_mon - 12*n_yr - 1) % 12 + 1 
        mon_stop_idx = (date_today.month + n_mon + 12*n_yr - 1) % 12 + 1 
        yr_start_idx = date_today.year + ((date_today.month - n_mon - 12*n_yr - 1) / 12).to_i
        yr_stop_idx = date_today.year + ((date_today.month + n_mon + 12*n_yr - 1) / 12).to_i 
        
        if is_included
          mon_start_idx = mon_start_idx % 12 + 1 
          yr_start_idx = yr_start_idx + (mon_start_idx / 12).to_i
        end

        # Creation of months ids has to be sorted in chronological order!
        for yr_idx in yr_start_idx..yr_stop_idx
          if yr_idx == yr_start_idx
            if yr_idx < yr_stop_idx
              loop_idx_start = mon_start_idx
              loop_idx_stop = 12
            else
              loop_idx_start = mon_start_idx
              loop_idx_stop = mon_stop_idx
            end

          elsif yr_idx < yr_stop_idx
            loop_idx_start = 1
            loop_idx_stop = 12
          else
            loop_idx_start = 1
            loop_idx_stop = mon_stop_idx
          end

          for month_idx in loop_idx_start..loop_idx_stop
            MonthApp.create(calendar_app_id: self.id, name: months_names[month_idx-1], month:month_idx, days: CalendarApp.calc_month_days(month_idx, yr_idx), numSpace:CalendarApp.calc_numSpace(month_idx, yr_idx), current_year: yr_idx)
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
        new_month = (mon.month + month_elapsed - 1) % 12 + 1
        new_year = mon.current_year + ((mon.month + month_elapsed - 1) / 12).to_i 
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
