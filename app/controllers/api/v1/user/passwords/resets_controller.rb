# frozen_string_literal: true

module API::V1
  class User::Passwords::ResetsController < BaseController
    skip_before_action :authenticate_user!

    def create
      ::User.send_reset_password_instructions(user_params)

      render_json_with_success(status: :ok)
    end

    def update
      case ::User.reset_password(password_params)
      in Solid::Success
        render_json_with_success(status: :ok)
      in Solid::Failure(:user_not_found, _)
        render_invalid_token
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end

    def password_params
      params.require(:user).permit(:token, :password, :password_confirmation)
    end

    def render_invalid_token
      render_json_with_error(status: :unprocessable_entity, message: "Invalid token")
    end
  end
end
