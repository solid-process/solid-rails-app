# frozen_string_literal: true

module Web::User
  class TokensController < BaseController
    def update
      current_user.token.regenerate_access_token

      redirect_to(web_user_settings_api_path, notice: "Access token updated.")
    end
  end
end
