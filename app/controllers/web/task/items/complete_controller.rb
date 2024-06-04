# frozen_string_literal: true

module Web::Task
  class Items::CompleteController < BaseController
    def update
      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Completion.call(task_list:, id: params[:id])
      in Solid::Success(task:)
        next_path = (params[:back_to] == "items") ? web_task_items_path : incomplete_web_task_items_path

        redirect_to next_path, notice: "Task marked as completed."
      end
    end
  end
end
