# frozen_string_literal: true

module Web::Tasks
  class Filter::AllController < BaseController
    def index
      tasks = current_task_list.tasks.order(created_at: :desc)

      render("web/tasks/filter/all", locals: {tasks:})
    end
  end
end
