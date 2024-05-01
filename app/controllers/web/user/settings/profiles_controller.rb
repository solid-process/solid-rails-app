# frozen_string_literal: true

module Web::User
  class Settings::ProfilesController < BaseController
    def show
      render("web/user/settings/profile", locals: {input: User::Password::Updating::Input.new})
    end
  end
end
