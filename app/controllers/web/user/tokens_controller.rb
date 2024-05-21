# frozen_string_literal: true

module Web::User
  class TokensController < BaseController
    def update
      current_user.token.refresh!

      cookies.encrypted[:user_token] = {value: current_user.token.value, expires: 30.seconds.from_now}

      redirect_to(web_user_settings_api_path, notice: "API token updated.")
    end
  end
end
