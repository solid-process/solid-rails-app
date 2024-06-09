# frozen_string_literal: true

module Web::User
  class TokensController < BaseController
    def update
      result = User.token.refresh(user: current_user)

      message =
        if result.success?
          cookies.encrypted[:user_token] = {value: result[:token].value, expires: 30.seconds.from_now}

          {notice: "API token updated."}
        else
          {alert: "API token cannot be updated."}
        end

      redirect_to(web_user_settings_api_path, message)
    end
  end
end
