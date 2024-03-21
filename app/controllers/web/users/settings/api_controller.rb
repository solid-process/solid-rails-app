# frozen_string_literal: true

module Web::Users
  class Settings::APIController < Settings::BaseController
    def show
      render("web/user/settings/api")
    end
  end
end
