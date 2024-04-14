# frozen_string_literal: true

module API::V1
  class Users::TokensController < BaseController
    def update
      case User::AccessToken::Refreshing.call(user: current_user)
      in Solid::Success(token:)
        render_json_with_success(status: :ok, data: {access_token: token.access_token})
      else
        render_json_with_error(status: :unprocessable_entity, message: "Access token cannot be updated")
      end
    end
  end
end
