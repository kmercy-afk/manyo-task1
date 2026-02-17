class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
    @tasks = @tasks.to_a   # ← FORCE execution (convert relation to array)
    puts "DEBUG: Loaded #{@tasks.count} tasks in controller (array size: #{@tasks.size})"
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = t('flash.create')
      redirect_to @task
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = t('flash.update')
      redirect_to @task
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = t('flash.destroy')
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :content)
  end
end