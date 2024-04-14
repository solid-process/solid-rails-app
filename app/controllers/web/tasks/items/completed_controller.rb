# frozen_string_literal: true

module Web::Tasks
  class Items::CompletedController < BaseController
    def index
      tasks = current_task_list.tasks.completed.order(completed_at: :desc)

      render("web/tasks/filter/completed", locals: {tasks:})
    end
  end
end
