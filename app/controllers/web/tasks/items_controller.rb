# frozen_string_literal: true

module Web::Tasks
  class ItemsController < BaseController
    before_action :set_task, only: [:edit, :update, :destroy]

    def index
      tasks = current_task_list.tasks.order(created_at: :desc)

      render("web/tasks/filter/all", locals: {tasks:})
    end

    def new
      render("web/tasks/items/new", locals: {task: Task.new})
    end

    def create
      task = current_task_list.tasks.build(task_params)

      if task.save
        redirect_to next_path, notice: "Task created"
      else
        render("web/tasks/items/new", locals: {task: task})
      end
    end

    def edit
      render("web/tasks/items/edit", locals: {task: @task})
    end

    def update
      if @task.update(task_params)

        redirect_to next_path, notice: "Task updated"
      else
        render("web/tasks/items/edit", locals: {task: @task})
      end
    end

    def destroy
      @task.destroy!

      redirect_to next_path, notice: "Task deleted"
    end

    private

    def set_task
      @task = current_task_list.tasks.find(params[:id])
    end

    def task_params
      if action_name.in?("create")
        params.require(:task).permit(:name)
      else
        params.require(:task).permit(:name, :completed)
      end
    end

    helper_method def next_path
      case params[:back_to]
      when "completed" then completed_web_tasks_path
      when "incomplete" then incomplete_web_tasks_path
      else web_tasks_path
      end
    end
  end
end
