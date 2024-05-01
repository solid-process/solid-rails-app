# frozen_string_literal: true

module Web::Task
  class Items::CompleteController < BaseController
    def update
      case Account::Task::Item::Completion.call(id: params[:id], member: current_member)
      in Solid::Success(task:)
        next_path = (params[:back_to] == "items") ? web_task_items_path : incomplete_web_task_items_path

        redirect_to next_path, notice: "Task marked as completed."
      end
    end
  end
end
