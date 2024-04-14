# frozen_string_literal: true

module Web::Tasks
  class Items::CompleteController < BaseController
    before_action :set_task, only: [:update]

    def update
      @task.complete!

      next_path = (params[:back_to] == "items") ? web_tasks_path : incomplete_web_tasks_path

      redirect_to next_path, notice: "Task marked as completed."
    end

    private

    def set_task
      @task = current_task_list.tasks.find(params[:id])
    end
  end
end
