# frozen_string_literal: true

module Web::Tasks
  class Filtered::AllController < BaseController
    def index
      tasks = current_task_list.tasks.order(created_at: :desc)

      render("web/tasks/filtered/all", locals: {tasks:})
    end
  end
end
