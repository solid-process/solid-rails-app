# frozen_string_literal: true

module API::V1
  class User::TokensController < BaseController
    def update
      case ::User.token.refresh(user: current_user)
      in Solid::Success(token:)
        render_json_with_success(status: :ok, data: {user_token: token.value})
      else
        render_json_with_error(status: :unprocessable_entity, message: "Access token cannot be updated")
      end
    end
  end
end
