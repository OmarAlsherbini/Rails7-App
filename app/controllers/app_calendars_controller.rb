class AppCalendarsController < ApplicationController
  before_action :set_app_calendar, only: %i[ show edit update destroy ]

  # GET /app_calendars or /app_calendars.json
  def index
    @app_calendars = AppCalendar.all
  end

  # GET /app_calendars/1 or /app_calendars/1.json
  def show
    @date_today = Time.current

  end

  # GET /app_calendars/new
  def new
    @app_calendar = AppCalendar.new
  end

  # GET /app_calendars/1/edit
  def edit
  end

  # POST /app_calendars or /app_calendars.json
  def create
    @app_calendar = AppCalendar.new(app_calendar_params)

    respond_to do |format|
      if @app_calendar.save
        save_success = true
      else
        save_success = false
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_calendar.errors, status: :unprocessable_entity }
      end
    end

    months_names = Array["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    day_names = Array["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    date_today = Time.current
    @app_calendar.current_year = AppYear.create(app_calendar_id: @app_calendar.id, yr: @date_today.year)
    @app_calendar.next_year = AppYear.create(app_calendar_id: @app_calendar.id, yr: @date_today.year+1)
    @app_calendar.past_year = AppYear.create(app_calendar_id: @app_calendar.id, yr: @date_today.year-1)
    @app_calendar.two_next_year = AppYear.create(app_calendar_id: @app_calendar.id, yr: @date_today.year+2)
    @app_calendar.two_past_year = AppYear.create(app_calendar_id: @app_calendar.id, yr: @date_today.year-2)
    for month_idx in 1..12
      mon = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.current_year.id, days: calc_month_days(month_idx, @app_calendar.current_year), numSpace:calc_numSpace(month_idx, @app_calendar.current_year), name: months_names[month_idx-1], month:month_idx)
      for day_idx in 1..mon.days
        AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.current_year.id, app_month_id: mon.id, day: day_idx, name:day_names[(mon.numSpace + day_idx - 1) % 7])
      end
    end
    if date_today.month == 6
      for month_idx in 1..12
        mon_prev_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.past_year.id, days: calc_month_days(month_idx, @app_calendar.past_year), numSpace:calc_numSpace(month_idx, @app_calendar.past_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_prev_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.past_year.id, app_month_id: mon_prev_yr.id, day: day_idx, name:day_names[(mon_prev_yr.numSpace + day_idx - 1) % 7])
        end
        mon_next_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.next_year.id, days: calc_month_days(month_idx, @app_calendar.next_year), numSpace:calc_numSpace(month_idx, @app_calendar.next_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_next_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.next_year.id, app_month_id: mon_next_yr.id, day: day_idx, name:day_names[(mon_next_yr.numSpace + day_idx - 1) % 7])
        end
      end
    elsif @date_today.month > 6
      for month_idx in 1..12
        # next_year
        mon_next_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.next_year.id, days: calc_month_days(month_idx, @app_calendar.next_year), numSpace:calc_numSpace(month_idx, @app_calendar.next_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_next_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.next_year.id, app_month_id: mon_next_yr.id, day: day_idx, name:day_names[(mon_next_yr.numSpace + day_idx - 1) % 7])
        end
      end
      mth_diff = @date_today.month - 6
      for month_idx in 1..mth_diff
        # two_next_year
        mon_two_next_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.two_next_year.id, days: calc_month_days(month_idx, @app_calendar.two_next_year), numSpace:calc_numSpace(month_idx, @app_calendar.two_next_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_two_next_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.two_next_year.id, app_month_id: mon_two_next_yr.id, day: day_idx, name:day_names[(mon_two_next_yr.numSpace + day_idx - 1) % 7])
        end
      end
      for month_idx in (mth_diff+1)..12
        # previous_year
        mon_prev_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.past_year.id, days: calc_month_days(month_idx, @app_calendar.past_year), numSpace:calc_numSpace(month_idx, @app_calendar.past_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_prev_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.past_year.id, app_month_id: mon_prev_yr.id, day: day_idx, name:day_names[(mon_prev_yr.numSpace + day_idx - 1) % 7])
        end
      end
    else
      for month_idx in 1..12
        # previous_year
        mon_prev_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.past_year.id, days: calc_month_days(month_idx, @app_calendar.past_year), numSpace:calc_numSpace(month_idx, @app_calendar.past_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_prev_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.past_year.id, app_month_id: mon_prev_yr.id, day: day_idx, name:day_names[(mon_prev_yr.numSpace + day_idx - 1) % 7])
        end
      end
      mth_diff = 6 - @date_today.month
      for month_idx in (12-mth_diff)..12
        # two_previous_year
        mon_two_prev_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.two_past_year.id, days: calc_month_days(month_idx, @app_calendar.two_past_year), numSpace:calc_numSpace(month_idx, @app_calendar.two_past_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_two_prev_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.two_past_year.id, app_month_id: mon_two_prev_yr.id, day: day_idx, name:day_names[(mon_two_prev_yr.numSpace + day_idx - 1) % 7])
        end
      end
      for month_idx in 1..(12-mth_diff)
        # next_year
        mon_next_yr = AppMonth.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.next_year.id, days: calc_month_days(month_idx, @app_calendar.next_year), numSpace:calc_numSpace(month_idx, @app_calendar.next_year), name: months_names[month_idx-1], month:month_idx)
        for day_idx in 1..mon_next_yr.days
          AppDay.create(app_calendar_id: @app_calendar.id, app_year_id: @app_calendar.next_year.id, app_month_id: mon_next_yr.id, day: day_idx, name:day_names[(mon_next_yr.numSpace + day_idx - 1) % 7])
        end
      end

    end

    if save_success
      format.html { redirect_to app_calendar_url(@app_calendar), notice: "App calendar was successfully created." }
      format.json { render :show, status: :created, location: @app_calendar }
    end

  end

  # PATCH/PUT /app_calendars/1 or /app_calendars/1.json
  def update
    respond_to do |format|
      if @app_calendar.update(app_calendar_params)
        format.html { redirect_to app_calendar_url(@app_calendar), notice: "App calendar was successfully updated." }
        format.json { render :show, status: :ok, location: @app_calendar }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_calendars/1 or /app_calendars/1.json
  def destroy
    @app_calendar.destroy

    respond_to do |format|
      format.html { redirect_to app_calendars_url, notice: "App calendar was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_calendar
      @app_calendar = AppCalendar.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_calendar_params
      params.fetch(:app_calendar, {})
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
