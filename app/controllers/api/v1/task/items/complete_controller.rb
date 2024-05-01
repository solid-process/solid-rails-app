# frozen_string_literal: true

module API::V1
  class Task::Items::CompleteController < BaseController
    include Task::Items::Concerns::Rendering

    def update
      case Account::Task::Item::Completion.call(member: current_member, id: params[:id])
      in Solid::Failure(:task_list_not_found | :task_not_found, _)
        render_task_or_list_not_found
      in Solid::Success(task:)
        render_json_with_attributes(task, :ok)
      end
    end
  end
end
