# frozen_string_literal: true

module Web::Task
  class ItemsController < BaseController
    before_action :set_task, only: [:edit, :update, :destroy]

    def index
      tasks = current_task_list.task_items.order(Arel.sql("task_items.completed_at DESC NULLS FIRST, task_items.created_at DESC"))

      render("web/task/items/index", locals: {tasks:, scope: "all"})
    end

    def new
      render("web/task/items/new", locals: {task: TaskItem.new})
    end

    def create
      task = current_task_list.task_items.build(task_params)

      if task.save
        redirect_to next_path, notice: "Task created."
      else
        render("web/task/items/new", locals: {task: task})
      end
    end

    def edit
      render("web/task/items/edit", locals: {task: @task})
    end

    def update
      if @task.update(task_params)

        redirect_to next_path, notice: "Task updated."
      else
        render("web/task/items/edit", locals: {task: @task})
      end
    end

    def destroy
      @task.destroy!

      redirect_to next_path, notice: "Task deleted."
    end

    private

    def set_task
      @task = current_task_list.task_items.find(params[:id])
    end

    def task_params
      case action_name
      when "create" then params.require(:task).permit(:name)
      when "update" then params.require(:task).permit(:name, :completed)
      end
    end

    helper_method def next_path
      case params[:back_to]
      when "completed" then completed_web_task_items_path
      when "incomplete" then incomplete_web_task_items_path
      else web_task_items_path
      end
    end
  end
end
