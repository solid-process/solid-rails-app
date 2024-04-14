# frozen_string_literal: true

module API::V1
  class Users::SessionsController < BaseController
    skip_before_action :authenticate_user!

    def create
      case User::Authentication.call(user_params)
      in Solid::Success(user:)
        render_json_with_success(status: :ok, data: {access_token: user.token.access_token})
      else
        render_json_with_error(status: :unauthorized, message: "Invalid email or password. Please try again.")
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
