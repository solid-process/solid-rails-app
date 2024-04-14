# frozen_string_literal: true

module Web::Tasks
  class Items::IncompleteController < BaseController
    def index
      case Account::Tasks::Item::Listing.call(filter: "incomplete", member: current_member)
      in Solid::Success(tasks:)
        render("web/tasks/filter/incomplete", locals: {tasks:})
      end
    end

    def update
      case Account::Tasks::Item::Incomplete.call(id: params[:id], member: current_member)
      in Solid::Success(task:)
        next_path = (params[:back_to] == "items") ? web_tasks_path : completed_web_tasks_path

        redirect_to next_path, notice: "Task marked as incomplete."
      end
    end
  end
end
