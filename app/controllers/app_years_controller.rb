class AppYearsController < ApplicationController
  before_action :set_app_year, only: %i[ show edit update destroy ]

  # GET /app_years or /app_years.json
  def index
    @app_years = AppYear.all
  end

  # GET /app_years/1 or /app_years/1.json
  def show
  end

  # GET /app_years/new
  def new
    @app_year = AppYear.new
  end

  # GET /app_years/1/edit
  def edit
  end

  # POST /app_years or /app_years.json
  def create
    @app_year = AppYear.new(app_year_params)

    respond_to do |format|
      if @app_year.save
        format.html { redirect_to app_year_url(@app_year), notice: "App year was successfully created." }
        format.json { render :show, status: :created, location: @app_year }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_years/1 or /app_years/1.json
  def update
    respond_to do |format|
      if @app_year.update(app_year_params)
        format.html { redirect_to app_year_url(@app_year), notice: "App year was successfully updated." }
        format.json { render :show, status: :ok, location: @app_year }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_years/1 or /app_years/1.json
  def destroy
    @app_year.destroy

    respond_to do |format|
      format.html { redirect_to app_years_url, notice: "App year was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_year
      @app_year = AppYear.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_year_params
      params.require(:app_year).permit(:app_calendar_id, :yr)
    end
end
