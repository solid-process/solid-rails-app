# frozen_string_literal: true

module Web::Users
  class Settings::ProfilesController < Settings::BaseController
    def show
      render("web/user/settings/profile", locals: {input: User::Password::Updating::Input.new})
    end
  end
end
