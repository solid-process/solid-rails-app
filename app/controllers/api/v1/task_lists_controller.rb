# frozen_string_literal: true

module API::V1
  class TaskListsController < BaseController
    before_action :set_task_list, only: [:update, :destroy]

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_json_with_error(status: :not_found, message: "Task or list not found")
    end

    TASK_LIST_ATTRIBUTES = [:id, :name, :created_at, :updated_at].freeze

    def index
      data =
        current_user
          .task_lists
          .order(created_at: :desc)
          .pluck(*TASK_LIST_ATTRIBUTES)
          .collect! { map_json_attributes(_1) }

      render_json_with_success(status: :ok, data:)
    end

    def create
      task_list = current_account.task_lists.new(task_list_params)

      if task_list.save
        render_json_with_attributes(task_list, :created)
      else
        render_json_with_model_errors(task_list)
      end
    end

    def update
      if @task_list.update(task_list_params)
        render_json_with_attributes(@task_list, :ok)
      else
        render_json_with_model_errors(@task_list)
      end
    end

    def destroy
      @task_list.destroy!

      render_json_with_success(status: :ok)
    end

    private

    def set_task_list
      @task_list = current_task_list!

      if @task_list.inbox?
        render_json_with_error(status: :forbidden, message: "Inbox cannot be updated or deleted")
      end
    end

    def task_list_params
      params.require(:task_list).permit(:name)
    end

    def map_json_attributes((id, name, created_at, updated_at))
      {id:, name:, created_at:, updated_at:}
    end

    def render_json_with_attributes(task_list, status)
      attributes = task_list.values_at(*TASK_LIST_ATTRIBUTES)

      data = map_json_attributes(attributes)

      render_json_with_success(status:, data:)
    end
  end
end
