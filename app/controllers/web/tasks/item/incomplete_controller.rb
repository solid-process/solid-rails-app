# frozen_string_literal: true

module Web::Tasks
  class Item::IncompleteController < BaseController
    before_action :set_task, only: [:update]

    def update
      @task.incomplete!

      next_path = (params[:back_to] == "all") ? web_tasks_all_path : web_tasks_completed_path

      redirect_to next_path, notice: "Task marked as incomplete"
    end

    private

    def set_task
      @task = current_task_list.tasks.find(params[:id])
    end
  end
end
