# frozen_string_literal: true

module API::V1
  class Users::TokensController < BaseController
    def update
      current_user.token.regenerate_access_token

      render_json_with_success(status: :ok, data: {access_token: current_user.token.access_token})
    end
  end
end
