# frozen_string_literal: true

module Web::Tasks
  class Items::IncompleteController < BaseController
    before_action :set_task, only: [:update]

    def index
      tasks = current_task_list.tasks.incomplete.order(created_at: :desc)

      render("web/tasks/filter/incomplete", locals: {tasks:})
    end

    def update
      @task.incomplete!

      next_path = (params[:back_to] == "items") ? web_tasks_path : completed_web_tasks_path

      redirect_to next_path, notice: "Task marked as incomplete."
    end

    private

    def set_task
      @task = current_task_list.tasks.find(params[:id])
    end
  end
end
