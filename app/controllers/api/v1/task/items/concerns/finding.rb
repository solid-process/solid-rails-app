# frozen_string_literal: true

module API::V1
  module Task::Items::Concerns::Finding
    extend ActiveSupport::Concern

    included do
      before_action :set_task_list

      rescue_from ActiveRecord::RecordNotFound do |exception|
        render_json_with_error(status: :not_found, message: "Task or list not found")
      end
    end

    private

    def set_task_list
      @task_list = current_task_list!
    end

    def set_task
      @task = @task_list.task_items.find(params[:id])
    end
  end
end
