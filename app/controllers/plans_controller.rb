class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_classroom, only: [:new, :index]

  rescue_from PlanGenerator::NoPlanFound, with: :no_plan_found

  def no_plan_found
    redirect_to classroom_path(@classroom), notice: "Unable to generate a new plan for this classroom. Please try adding another bag."
  end

  # GET /plans
  # GET /plans.json
  def index
    @plans = @classroom.plans
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /classrooms/:classroom_id/plans/new

  def new
    name = Time.now.strftime("%Y-%m-%d")
    @plan = Plan.new classroom: @classroom, name: name
    pg = PlanGenerator.new(@classroom.students, @classroom.book_bags)
    assignments = pg.generate
    @plan.assignments += assignments
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)

    respond_to do |format|
      if @plan.save
        format.html { redirect_to classroom_url(@plan.classroom), notice: 'Plan was successfully created.' }
        format.json { render action: 'show', status: :created, location: @plan }
      else
        format.html { render action: 'new' }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: 'Plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to classroom_url(@plan.classroom), notice: "Plan was successfully deleted" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  def set_classroom
    @classroom = Classroom.find(params[:classroom_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(:name, :classroom_id, assignments_attributes: [:book_bag_id, :student_id])
  end
end
