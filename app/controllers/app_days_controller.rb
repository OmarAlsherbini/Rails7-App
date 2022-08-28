class AppDaysController < ApplicationController
  before_action :set_app_day, only: %i[ show edit update destroy ]

  # GET /app_days or /app_days.json
  def index
    @app_days = AppDay.all
  end

  # GET /app_days/1 or /app_days/1.json
  def show
  end

  # GET /app_days/new
  def new
    @app_day = AppDay.new
  end

  # GET /app_days/1/edit
  def edit
  end

  # POST /app_days or /app_days.json
  def create
    @app_day = AppDay.new(app_day_params)

    respond_to do |format|
      if @app_day.save
        format.html { redirect_to app_day_url(@app_day), notice: "App day was successfully created." }
        format.json { render :show, status: :created, location: @app_day }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_days/1 or /app_days/1.json
  def update
    respond_to do |format|
      if @app_day.update(app_day_params)
        format.html { redirect_to app_day_url(@app_day), notice: "App day was successfully updated." }
        format.json { render :show, status: :ok, location: @app_day }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_days/1 or /app_days/1.json
  def destroy
    @app_day.destroy

    respond_to do |format|
      format.html { redirect_to app_days_url, notice: "App day was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_day
      @app_day = AppDay.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_day_params
      params.require(:app_day).permit(:app_calendar_id, :app_year_id, :app_month_id, :day, :name)
    end
end
