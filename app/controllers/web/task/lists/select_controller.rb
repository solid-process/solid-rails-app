# frozen_string_literal: true

module Web::Task
  class Lists::SelectController < BaseController
    before_action :set_task_list, only: [:update]

    def update
      self.current_task_list_id = @task_list.id

      redirect_to web_task_lists_path, notice: "Task list selected."
    end

    private

    def set_task_list
      @task_list = current_user.task_lists.find(params[:id])
    end
  end
end
