class AppCalendarsController < ApplicationController
  before_action :set_app_calendar, only: %i[ show edit update destroy ]

  # GET /app_calendars or /app_calendars.json
  def index
    @app_calendars = AppCalendar.all
    
  end

  # GET /app_calendars/1 or /app_calendars/1.json
  def show
    @date_today = Time.current
    @app_years = AppYear.where(app_calendar_id: params[:id])
    @current_year = AppCalendar.find(params[:id]).current_year
    @next_year = AppYear.where(app_calendar_id: AppCalendar.find(params[:id]).next_year)
    @past_year = AppYear.where(app_calendar_id: AppCalendar.find(params[:id]).past_year)
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
        format.html { redirect_to app_calendar_url(@app_calendar), notice: "App calendar was successfully created." }
        format.json { render :show, status: :created, location: @app_calendar }
      else
        save_success = false
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_calendar.errors, status: :unprocessable_entity }
      end
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

end
