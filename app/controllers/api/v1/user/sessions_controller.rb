# frozen_string_literal: true

module API::V1
  class User::SessionsController < BaseController
    skip_before_action :authenticate_user!

    def create
      case ::User.authenticate(user_params)
      in Solid::Success(user:)
        token = ::User.token.repository.find_by_user(id: user.id).fetch(:token)

        render_json_with_success(status: :ok, data: {user_token: token.value})
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
