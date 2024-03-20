# frozen_string_literal: true

module Web::Tasks
  class ItemController < BaseController
    before_action :set_task, only: [:edit, :update, :destroy]

    def new
      render("web/tasks/item/new", locals: {task: Task.new})
    end

    def create
      task = current_task_list.tasks.build(task_params)

      if task.save
        redirect_to next_path, notice: "Task created"
      else
        render("web/tasks/item/new", locals: {task: task})
      end
    end

    def edit
      render("web/tasks/item/edit", locals: {task: @task})
    end

    def update
      if @task.update(task_params)

        redirect_to next_path, notice: "Task updated"
      else
        render("web/tasks/item/edit", locals: {task: @task})
      end
    end

    def destroy
      @task.destroy!

      redirect_to next_path, notice: "Task deleted"
    end

    private

    def next_path
      case params[:back_to]
      when "completed" then web_tasks_completed_path
      when "incomplete" then web_tasks_incomplete_path
      else web_tasks_all_path
      end
    end

    def task_params
      if action_name.in?("create")
        params.require(:task).permit(:name)
      else
        params.require(:task).permit(:name, :completed)
      end
    end

    def set_task
      @task = current_task_list.tasks.find(params[:id])
    end
  end
end
