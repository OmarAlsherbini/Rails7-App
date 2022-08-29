class TestChildrenController < ApplicationController
  before_action :set_test_child, only: %i[ show edit update destroy ]

  # GET /test_children or /test_children.json
  def index
    @test_children = TestChild.all
  end

  # GET /test_children/1 or /test_children/1.json
  def show
  end

  # GET /test_children/new
  def new
    @test_child = TestChild.new
  end

  # GET /test_children/1/edit
  def edit
  end

  # POST /test_children or /test_children.json
  def create
    @test_child = TestChild.new(test_child_params)

    respond_to do |format|
      if @test_child.save
        format.html { redirect_to test_child_url(@test_child), notice: "Test child was successfully created." }
        format.json { render :show, status: :created, location: @test_child }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @test_child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_children/1 or /test_children/1.json
  def update
    respond_to do |format|
      if @test_child.update(test_child_params)
        format.html { redirect_to test_child_url(@test_child), notice: "Test child was successfully updated." }
        format.json { render :show, status: :ok, location: @test_child }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @test_child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_children/1 or /test_children/1.json
  def destroy
    @test_child.destroy

    respond_to do |format|
      format.html { redirect_to test_children_url, notice: "Test child was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_child
      @test_child = TestChild.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def test_child_params
      params.require(:test_child).permit(:test_parent_id)
    end
end
