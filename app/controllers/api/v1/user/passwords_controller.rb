# frozen_string_literal: true

module API::V1
  class User::PasswordsController < BaseController
    def update
      password_params[:password_challenge] = password_params.delete(:current_password)

      if current_user.update(password_params)
        render_json_with_success(status: :ok)
      else
        message = current_user.errors.full_messages.join(", ")
        message.gsub!("Password challenge", "Current password")

        details = current_user.errors.to_hash
        details[:current_password] = details.delete(:password_challenge) if details[:password_challenge]

        render_json_with_error(status: :unprocessable_entity, message:, details:)
      end
    end

    private

    def password_params
      @password_params ||= params.require(:user).permit(
        :current_password,
        :password,
        :password_confirmation
      ).with_defaults(current_password: "")
    end
  end
end
