# frozen_string_literal: true

module Web::Task
  class Items::IncompleteController < BaseController
    def index
      case Account::Task::Item::Listing.call(filter: "incomplete", member: current_member)
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "incomplete"})
      end
    end

    def update
      case Account::Task::Item::Incomplete.call(id: params[:id], member: current_member)
      in Solid::Success(task:)
        next_path = (params[:back_to] == "items") ? web_task_items_path : completed_web_task_items_path

        redirect_to next_path, notice: "Task marked as incomplete."
      end
    end
  end
end
