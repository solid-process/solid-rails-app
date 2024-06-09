# frozen_string_literal: true

module Web::User
  class Settings::ProfilesController < BaseController
    def show
      render("web/user/settings/profile", locals: {input: User.update_password.input.new})
    end
  end
end
