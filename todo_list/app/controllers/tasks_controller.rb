class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :toggle_complete]
  before_action :order_tasks, only: [:index, :filter]
  include TasksHelper

  # GET /tasks
  # GET /tasks.json
  def index
  end

  # GET /tasks/filter/:filter
  # GET /tasks/filter/:filter.json
  def filter
    filter = params[:filter]
    filters = {
      "all" => @tasks,
      "active" => @tasks.where(completed: false),
      "completed" => @tasks.where(completed: true)
    }
    @tasks = filters[filter]
    render 'index'
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1/complete
  # PATCH/PUT /tasks/1/complete.json
  def toggle_complete
    @task.completed = !@task.completed
    @task.save

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Task was successfully updated.' }
      format.json { render :show, status: :ok, location: @task }
    end
  end

  # PATCH/PUT /tasks/complete_all
  def complete_all
    Task.all.each { |task| task.completed = true; task.save }

    redirect_to root_path
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /tasks/clear_completed
  # DELETE /tasks/clear_completed.json
  def clear_completed
    Task.destroy_all(completed: true)
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def order_tasks
      @tasks = Task.order(created_at: :desc)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:description)
    end
end
