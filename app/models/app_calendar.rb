class AppCalendar < ApplicationRecord
    has_many :app_year
    has_many :app_month
    has_many :app_day
    after_create :build_calendar

    private

    def build_calendar
        months_names = Array["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        day_names = Array["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        date_today = Time.current
        current_year = AppYear.create(app_calendar_id: self.id, yr: date_today.year)
        next_year = AppYear.create(app_calendar_id: self.id, yr: date_today.year+1)
        past_year = AppYear.create(app_calendar_id: self.id, yr: date_today.year-1)
        two_next_year = AppYear.create(app_calendar_id: self.id, yr: date_today.year+2)
        two_past_year = AppYear.create(app_calendar_id: self.id, yr: date_today.year-2)
        self.current_year = current_year.id
        self.next_year = next_year.id
        self.past_year = past_year.id
        self.two_next_year = two_next_year.id
        self.two_past_year = two_past_year.id
        self.save
        # Current Year Months
        for month_idx in 1..12
            mon = AppMonth.create(app_calendar_id: self.id, app_year_id: self.current_year, days: calc_month_days(month_idx, AppYear.find(self.current_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.current_year).yr), name: months_names[month_idx-1], month:month_idx)
            """
            for day_idx in 1..mon.days
                AppDay.create(app_calendar_id: self.id, app_year_id: self.current_year, app_month_id: mon.id, day: day_idx, name:day_names[(mon.numSpace + day_idx - 1) % 7])
            end
            """
            if month_idx == date_today.month
                self.current_month = mon.id
                self.save
            elsif month_idx == date_today.month - 1
                self.previous_month = mon.id
                self.save
            elsif month_idx == date_today.month + 1
                self.next_month = mon.id
                self.save
            end
        end
        # Next and Previous 17 months are determined by current month, whether you will need 2 years ahead or 2 years behind or exactly 1 ahead and 1 behind if current month is June. This assumes current month counts among the past 18 months as well!
        if date_today.month == 6
            for month_idx in 1..12
                mon_prev_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.past_year, days: calc_month_days(month_idx, AppYear.find(self.past_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.past_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_prev_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.past_year, app_month_id: mon_prev_yr.id, day: day_idx, name:day_names[(mon_prev_yr.numSpace + day_idx - 1) % 7])
                end
                """
                mon_next_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.next_year, days: calc_month_days(month_idx, AppYear.find(self.next_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.next_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_next_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.next_year, app_month_id: mon_next_yr.id, day: day_idx, name:day_names[(mon_next_yr.numSpace + day_idx - 1) % 7])
                end
                """
            end
        elsif date_today.month > 6
            for month_idx in 1..12
                # next_year
                mon_next_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.next_year, days: calc_month_days(month_idx, AppYear.find(self.next_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.next_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_next_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.next_year, app_month_id: mon_next_yr.id, day: day_idx, name:day_names[(mon_next_yr.numSpace + day_idx - 1) % 7])
                end
                """
                if date_today == 12 and month_idx == 1
                    self.next_month = mon_next_yr.id
                    self.save
                end
            end
            mth_diff = date_today.month - 6
            for month_idx in 1..mth_diff
                # two_next_year
                mon_two_next_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.two_next_year, days: calc_month_days(month_idx, AppYear.find(self.two_next_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.two_next_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_two_next_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.two_next_year, app_month_id: mon_two_next_yr.id, day: day_idx, name:day_names[(mon_two_next_yr.numSpace + day_idx - 1) % 7])
                end
                """
            end
            for month_idx in (mth_diff+1)..12
                # previous_year
                mon_prev_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.past_year, days: calc_month_days(month_idx, AppYear.find(self.past_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.past_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_prev_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.past_year, app_month_id: mon_prev_yr.id, day: day_idx, name:day_names[(mon_prev_yr.numSpace + day_idx - 1) % 7])
                end
                """
            end
        else
            for month_idx in 1..12
                # previous_year
                mon_prev_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.past_year, days: calc_month_days(month_idx, AppYear.find(self.past_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.past_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_prev_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.past_year, app_month_id: mon_prev_yr.id, day: day_idx, name:day_names[(mon_prev_yr.numSpace + day_idx - 1) % 7])
                end
                """
                if date_today == 1 and month_idx == 12
                    self.next_month = mon_prev_yr.id
                    self.save
                end
            end
            mth_diff = 6 - date_today.month
            for month_idx in (12-mth_diff)..12
                # two_previous_year
                mon_two_prev_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.two_past_year, days: calc_month_days(month_idx, AppYear.find(self.two_past_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.two_past_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_two_prev_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.two_past_year, app_month_id: mon_two_prev_yr.id, day: day_idx, name:day_names[(mon_two_prev_yr.numSpace + day_idx - 1) % 7])
                end
                """
            end
            for month_idx in 1..(12-mth_diff)
                # next_year
                mon_next_yr = AppMonth.create(app_calendar_id: self.id, app_year_id: self.next_year, days: calc_month_days(month_idx, AppYear.find(self.next_year).yr), numSpace:calc_numSpace(month_idx, AppYear.find(self.next_year).yr), name: months_names[month_idx-1], month:month_idx)
                """
                for day_idx in 1..mon_next_yr.days
                    AppDay.create(app_calendar_id: self.id, app_year_id: self.next_year, app_month_id: mon_next_yr.id, day: day_idx, name:day_names[(mon_next_yr.numSpace + day_idx - 1) % 7])
                end
                """
            end
        end
    end

      def calc_month_days(month_index, month_year)
        month_days = Array[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if month_index != 2 and month_year % 4 != 0
          return month_days[month_index+1]
        else
          return 29
        end
      end
  
      def calc_numSpace(month_index, month_year)
        month_days = Array[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
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
            return (numspace_current + month_days[(month_current-1)..(month_index-2)].sum + check_feb(month_index, month_current, month_year, year_current)) % 7
          else
            # numspace_current + shift + 1 day shift of potential 29-day February
            return (numspace_current + month_days[(month_index-1)..(month_current-2)].sum + check_feb(month_index, month_current, month_year, year_current)) % 7
          end
        
        elsif month_year > year_current
          overall_numspace_shift = 0
          for year_idx in year_current..month_year
            if year_idx == year_current
              overall_numspace_shift = overall_numspace_shift + month_days[(month_current-1)..12].sum
            elsif year_idx == month_year
              overall_numspace_shift = overall_numspace_shift + month_days[1..(month_index-2)].sum
            else
              overall_numspace_shift = overall_numspace_shift + 365
            end
          end
          return (numspace_current + overall_numspace_shift + check_feb(month_index, month_current, month_year, year_current)) % 7
        
        else
          overall_numspace_shift = 0
          for year_idx in month_year..year_current
            if year_idx == month_year
              overall_numspace_shift = overall_numspace_shift + month_days[(month_index-1)..12].sum
            elsif year_idx == year_current
              overall_numspace_shift = overall_numspace_shift + month_days[1..(month_current-2)].sum
            else
              overall_numspace_shift = overall_numspace_shift + 365
            end
          end
          return (numspace_current + overall_numspace_shift + check_feb(month_index, month_current, month_year, year_current)) % 7
  
        end
        return 
  
      end
  
      # Add 1 to numSpace if the calculation involve a 29-day February
      def check_feb(month_index, month_current, month_year, year_current)
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
          for year_idx in year_current..month_year
            if year_idx % 4 == 0
              if year_idx > year_current
                if year_idx < month_year or month_index > 2
                  return 1
                end
              elsif month_current <= 2
                return 1
              end
            end
          end
          return 0
        
        else
          for year_idx in month_year..year_current
            if year_idx % 4 == 0
              if year_idx > month_year
                if year_idx < year_current or month_current > 2
                  return 1
                end
              elsif month_index <= 2
                return 1
              end
            end
          end
          return 0
        end
  
      end


end
