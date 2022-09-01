class MonthAppsController < ApplicationController
  before_action :set_month_app, only: %i[ show edit update destroy ]

  # GET /month_apps or /month_apps.json
  def index
    @month_apps = MonthApp.all
  end

  # GET /month_apps/1 or /month_apps/1.json
  def show
  end

  # GET /month_apps/new
  def new
    @month_app = MonthApp.new
  end

  # GET /month_apps/1/edit
  def edit
  end

  # POST /month_apps or /month_apps.json
  def create
    @month_app = MonthApp.new(month_app_params)

    respond_to do |format|
      if @month_app.save
        format.html { redirect_to month_app_url(@month_app), notice: "Month app was successfully created." }
        format.json { render :show, status: :created, location: @month_app }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @month_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /month_apps/1 or /month_apps/1.json
  def update
    respond_to do |format|
      if @month_app.update(month_app_params)
        format.html { redirect_to month_app_url(@month_app), notice: "Month app was successfully updated." }
        format.json { render :show, status: :ok, location: @month_app }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @month_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /month_apps/1 or /month_apps/1.json
  def destroy
    @month_app.destroy

    respond_to do |format|
      format.html { redirect_to month_apps_url, notice: "Month app was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_month_app
      @month_app = MonthApp.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def month_app_params
      params.require(:month_app).permit(:calendar_app_id, :name, :month, :days, :numSpace, :current_year)
    end
end
