# frozen_string_literal: true

module Web::User
  class Settings::ProfilesController < BaseController
    def show
      render("web/user/settings/profile")
    end
  end
end
