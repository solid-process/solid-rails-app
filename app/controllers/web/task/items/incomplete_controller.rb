# frozen_string_literal: true

module Web::Task
  class Items::IncompleteController < BaseController
    def index
      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Listing.call(task_list:, filter: "incomplete")
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "incomplete"})
      end
    end

    def update
      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Incomplete.call(task_list:, id: params[:id])
      in Solid::Success(task:)
        next_path = (params[:back_to] == "items") ? web_task_items_path : completed_web_task_items_path

        redirect_to next_path, notice: "Task marked as incomplete."
      end
    end
  end
end
