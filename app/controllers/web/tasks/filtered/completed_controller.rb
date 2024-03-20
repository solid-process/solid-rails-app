# frozen_string_literal: true

module Web::Tasks
  class Filtered::CompletedController < BaseController
    def index
      tasks = current_task_list.tasks.completed.order(created_at: :desc)

      render("web/tasks/filtered/completed", locals: {tasks:})
    end
  end
end
