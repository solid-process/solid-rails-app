# frozen_string_literal: true

module API::V1
  class Task::ItemsController < BaseController
    include Task::Items::Concerns::Rendering

    def index
      case Account::Task::Item::Listing.call(
        member: current_member,
        filter: params[:filter]
      )
      in Solid::Failure(:task_list_not_found, _)
        render_task_or_list_not_found
      in Solid::Success(tasks:)
        data = tasks.pluck(task_attribute_names).collect! { map_json_attributes(_1) }

        render_json_with_success(status: :ok, data:)
      end
    end

    def create
      create_params = params.require(:task).permit(:name)

      create_input = {member: current_member, **create_params}

      case Account::Task::Item::Creation.call(create_input)
      in Solid::Failure(:task_list_not_found | :task_not_found, _)
        render_task_or_list_not_found
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      in Solid::Success(task:)
        render_json_with_attributes(task, :created)
      end
    end

    def update
      update_params = params.require(:task).permit(:name, :completed)

      update_input = {member: current_member, id: params[:id], **update_params}

      case Account::Task::Item::Updating.call(update_input)
      in Solid::Failure(:task_list_not_found | :task_not_found, _)
        render_task_or_list_not_found
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      in Solid::Success(task:)
        render_json_with_attributes(task, :ok)
      end
    end

    def destroy
      case Account::Task::Item::Deletion.call(member: current_member, id: params[:id])
      in Solid::Failure(:task_list_not_found | :task_not_found, _)
        render_task_or_list_not_found
      in Solid::Success
        render_json_with_success(status: :ok)
      end
    end
  end
end
