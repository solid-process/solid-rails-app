# frozen_string_literal: true

module Web::Tasks
  class ItemController < BaseController
    def new
      render("web/tasks/item/new")
    end

    def edit
      render("web/tasks/item/edit")
    end
  end
end
