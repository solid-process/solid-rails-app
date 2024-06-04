# frozen_string_literal: true

module Web::User
  class Settings::APIController < BaseController
    def show
      user_token = cookies.encrypted[:user_token] || find_user_token.value

      render("web/user/settings/api", locals: {user_token:})
    end

    private

    def find_user_token
      ::User::Token::Repository.find_by_user(id: current_user.id).fetch(:token)
    end
  end
end
