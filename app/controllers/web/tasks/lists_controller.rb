# frozen_string_literal: true

module Web::Tasks
  class ListsController < BaseController
    def index
      render("web/tasks/lists/index")
    end
  end
end
