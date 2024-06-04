# frozen_string_literal: true

module Web::Task
  class Items::CompletedController < BaseController
    def index
      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Listing.call(task_list:, filter: "completed")
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "completed"})
      end
    end
  end
end
