# frozen_string_literal: true

module API::V1
  class User::TokensController < BaseController
    def update
      current_user.token.refresh_access_token!

      render_json_with_success(status: :ok, data: {access_token: current_user.token.access_token})
    end
  end
end
