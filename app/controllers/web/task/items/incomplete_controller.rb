# frozen_string_literal: true

module Web::Task
  class Items::IncompleteController < BaseController
    before_action :set_task, only: [:update]

    def index
      tasks = current_task_list.task_items.incomplete.order(created_at: :desc)

      render("web/task/items/index", locals: {tasks:, scope: "incomplete"})
    end

    def update
      @task.incomplete!

      next_path = (params[:back_to] == "items") ? web_task_items_path : completed_web_task_items_path

      redirect_to next_path, notice: "Task marked as incomplete."
    end

    private

    def set_task
      @task = current_task_list.task_items.find(params[:id])
    end
  end
end
