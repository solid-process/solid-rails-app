# frozen_string_literal: true

module Web::Users
  class Settings::ProfilesController < Settings::BaseController
    def show
      render("web/user/settings/profile")
    end
  end
end
