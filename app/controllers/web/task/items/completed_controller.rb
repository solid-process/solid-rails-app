# frozen_string_literal: true

module Web::Task
  class Items::CompletedController < BaseController
    def index
      case Account::Task::Item::Listing.call(filter: "completed", member: current_member)
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "completed"})
      end
    end
  end
end
