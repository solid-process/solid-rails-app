# frozen_string_literal: true

module Web::Tasks
  class Filter::CompletedController < BaseController
    def index
      tasks = current_task_list.tasks.completed.order(created_at: :desc)

      render("web/tasks/filter/completed", locals: {tasks:})
    end
  end
end
