# frozen_string_literal: true

module Web::Tasks
  class Items::CompletedController < BaseController
    def index
      case Account::Tasks::Item::Listing.call(filter: "completed", member: current_member)
      in Solid::Success(tasks:)
        render("web/tasks/filter/completed", locals: {tasks:})
      end
    end
  end
end
