class AppMonthsController < ApplicationController
  before_action :set_app_month, only: %i[ show edit update destroy ]

  # GET /app_months or /app_months.json
  def index
    @app_months = AppMonth.all
  end

  # GET /app_months/1 or /app_months/1.json
  def show
  end

  # GET /app_months/new
  def new
    @app_month = AppMonth.new
  end

  # GET /app_months/1/edit
  def edit
  end

  # POST /app_months or /app_months.json
  def create
    @app_month = AppMonth.new(app_month_params)

    respond_to do |format|
      if @app_month.save
        format.html { redirect_to app_month_url(@app_month), notice: "App month was successfully created." }
        format.json { render :show, status: :created, location: @app_month }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_months/1 or /app_months/1.json
  def update
    respond_to do |format|
      if @app_month.update(app_month_params)
        format.html { redirect_to app_month_url(@app_month), notice: "App month was successfully updated." }
        format.json { render :show, status: :ok, location: @app_month }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_months/1 or /app_months/1.json
  def destroy
    @app_month.destroy

    respond_to do |format|
      format.html { redirect_to app_months_url, notice: "App month was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_month
      @app_month = AppMonth.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_month_params
      params.require(:app_month).permit(:app_calendar_id, :app_year_id, :days, :numSpaces, :name, :month)
    end
end
