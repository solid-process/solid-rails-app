# frozen_string_literal: true

module Web::Users
  class TokensController < BaseController
    def update
      current_user.token.refresh_access_token!

      redirect_to(web_users_settings_api_path, notice: "API token regenerated")
    end
  end
end
