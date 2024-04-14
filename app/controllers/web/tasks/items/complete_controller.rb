# frozen_string_literal: true

module Web::Tasks
  class Items::CompleteController < BaseController
    def update
      case Account::Tasks::Item::Completion.call(id: params[:id], member: current_member)
      in Solid::Success(task:)
        next_path = (params[:back_to] == "items") ? web_tasks_path : incomplete_web_tasks_path

        redirect_to next_path, notice: "Task marked as completed."
      end
    end
  end
end
