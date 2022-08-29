class TestParentsController < ApplicationController
  before_action :set_test_parent, only: %i[ show edit update destroy ]
  


  # GET /test_parents or /test_parents.json
  def index
    @test_parents = TestParent.all
  end

  # GET /test_parents/1 or /test_parents/1.json
  def show
  end

  # GET /test_parents/new
  def new
    @test_parent = TestParent.new
  end

  # GET /test_parents/1/edit
  def edit
  end

  # POST /test_parents or /test_parents.json
  def create
    @test_parent = TestParent.new(test_parent_params)

    respond_to do |format|
      if @test_parent.save
        save_success = true
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @test_parent.errors, status: :unprocessable_entity }
      end
    end
    
    if save_success
      format.html { redirect_to test_parent_url(@test_parent), notice: "Test parent was successfully created." }
      format.json { render :show, status: :created, location: @test_parent }
    end
    
  end

  # PATCH/PUT /test_parents/1 or /test_parents/1.json
  def update
    respond_to do |format|
      if @test_parent.update(test_parent_params)
        format.html { redirect_to test_parent_url(@test_parent), notice: "Test parent was successfully updated." }
        format.json { render :show, status: :ok, location: @test_parent }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @test_parent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_parents/1 or /test_parents/1.json
  def destroy
    @test_parent.destroy

    respond_to do |format|
      format.html { redirect_to test_parents_url, notice: "Test parent was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_parent
      @test_parent = TestParent.find(params[:id])
    end

    

    # Only allow a list of trusted parameters through.
    def test_parent_params
      params.fetch(:test_parent, {})
    end
end
