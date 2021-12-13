class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :authenticate_current_user!
  
  def index
    @tasks = Task.where(project_id: @project.id)
  end

  def show
    @comment = Comment.new
  end

  def new
    @task = Task.new
  end

  def edit
    @project = Project.find_by(id: @task.project_id)
  end

  def create
    @task ||=
    CreateTask.call(current_user: current_user,task_params: task_params)
      if @task.success!
        redirect_to project_path(task_params[:project_id]), notice: "Task created successfully "
      else
        redirect_to project_path(task_params[:project_id]), notice: "Task create failed"  
      end
  end

  def update
      UpdateTask.call(task_params: task_params)
      if @task.success!
        redirect_to project_path(@task.project_id), notice: "Task create failed"  
      else
        redirect_to edit_task_path(@task), notice: "Task create failed"  
      end
  end

  def destroy
    id = @task.project_id
    DestroyTask.call(id: @task.id, current_user: current_user)
    redirect_to project_path(id), notice: "Task destroyed successfully"
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:id, :title, :description, :deadline_at, :project_id, :status)
    end
  
    def require_login
      unless current_user
        redirect_to new_user_registration_path
        end
    end  
end