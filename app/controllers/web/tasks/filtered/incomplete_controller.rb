# frozen_string_literal: true

module Web::Tasks
  class Filtered::IncompleteController < BaseController
    def index
      render("web/tasks/filtered/incomplete")
    end
  end
end
