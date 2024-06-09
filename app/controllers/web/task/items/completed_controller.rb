# frozen_string_literal: true

module Web::Task
  class Items::CompletedController < BaseController
    def index
      task_list = Account.task_list.entity(current_member)

      case Account.task_item.list(task_list:, filter: "completed")
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "completed"})
      end
    end
  end
end
