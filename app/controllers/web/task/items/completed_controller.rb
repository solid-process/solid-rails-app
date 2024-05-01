# frozen_string_literal: true

module Web::Task
  class Items::CompletedController < BaseController
    def index
      tasks = current_task_list.task_items.completed.order(completed_at: :desc)

      render("web/task/items/index", locals: {tasks:, scope: "completed"})
    end
  end
end
