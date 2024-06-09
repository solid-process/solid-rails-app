# frozen_string_literal: true

module Web::Task
  class Items::IncompleteController < BaseController
    def index
      task_list = Account.task_list.entity(current_member)

      case Account.task_item.list(task_list:, filter: "incomplete")
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "incomplete"})
      end
    end

    def update
      task_list = Account.task_list.entity(current_member)

      case Account.task_item.incomplete(task_list:, id: params[:id])
      in Solid::Success(task:)
        next_path = (params[:back_to] == "items") ? web_task_items_path : completed_web_task_items_path

        redirect_to next_path, notice: "Task marked as incomplete."
      end
    end
  end
end
