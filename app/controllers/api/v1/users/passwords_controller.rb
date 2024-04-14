# frozen_string_literal: true

module API::V1
  class Users::PasswordsController < BaseController
    def update
      case User::Password::Updating.call(user: current_user, **password_params)
      in Solid::Success
        render_json_with_success(status: :ok)
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      end
    end

    private

    def password_params
      params.require(:user).permit(
        :current_password,
        :password,
        :password_confirmation
      ).with_defaults(current_password: "")
    end
  end
end
