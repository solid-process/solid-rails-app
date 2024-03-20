# frozen_string_literal: true

module Web::Tasks
  class Filtered::CompletedController < BaseController
    def index
      render("web/tasks/filtered/completed")
    end
  end
end
