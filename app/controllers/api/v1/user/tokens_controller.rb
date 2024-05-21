# frozen_string_literal: true

module API::V1
  class User::TokensController < BaseController
    def update
      current_user.token.refresh!

      render_json_with_success(status: :ok, data: {user_token: current_user.token.value})
    end
  end
end
