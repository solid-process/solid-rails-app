# frozen_string_literal: true

module Web::Tasks
  class Filtered::IncompleteController < BaseController
    def index
      tasks = current_task_list.tasks.incomplete.order(created_at: :desc)

      render("web/tasks/filtered/incomplete", locals: {tasks:})
    end
  end
end
