# frozen_string_literal: true

module API::V1
  class TaskListsController < BaseController
    TASK_LIST_ATTRIBUTES = [:id, :name, :created_at, :updated_at].freeze

    def index
      result = Account::Tasks::List::Listing.call(account: current_member)

      data = result[:relation].pluck(*TASK_LIST_ATTRIBUTES).collect! { map_json_attributes(_1) }

      render_json_with_success(status: :ok, data:)
    end

    def create
      case Account::Tasks::List::Creation.call(account: current_member, **task_list_params)
      in Solid::Success(task_list:)
        render_json_with_attributes(task_list, :created)
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      end
    end

    def update
      case Account::Tasks::List::Updating.call(account: current_member, id: params[:id], **task_list_params)
      in Solid::Failure(input:) then render_json_with_model_errors(input)
      in Solid::Failure(:task_list_not_found, _) then render_task_list_not_found
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_cannot_update_or_delete_inbox
      in Solid::Success(task_list:)
        render_json_with_attributes(task_list, :ok)
      end
    end

    def destroy
      case Account::Tasks::List::Deletion.call(account: current_member, id: params[:id])
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_cannot_update_or_delete_inbox
      in Solid::Failure(:task_list_not_found, _) then render_task_list_not_found
      in Solid::Success
        render_json_with_success(status: :ok)
      end
    end

    private

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

    def render_cannot_update_or_delete_inbox
      render_json_with_error(status: :forbidden, message: "Inbox cannot be updated or deleted")
    end

    def render_task_list_not_found
      render_json_with_error(status: :not_found, message: "Task list not found")
    end
  end
end
