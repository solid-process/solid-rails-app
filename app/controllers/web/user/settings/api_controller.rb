# frozen_string_literal: true

module Web::User
  class Settings::APIController < BaseController
    def show
      render("web/user/settings/api")
    end
  end
end
