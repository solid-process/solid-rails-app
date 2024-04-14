# frozen_string_literal: true

module Web::Users
  class TokensController < BaseController
    def update
      result = User::AccessToken::Refreshing.call(user: current_user)

      message = result.success? ? {notice: "Access token updated."} : {alert: "Access token cannot be updated."}

      redirect_to(web_users_settings_api_path, message)
    end
  end
end
