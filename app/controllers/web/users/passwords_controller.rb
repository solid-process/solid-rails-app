# frozen_string_literal: true

module Web::Users
  class PasswordsController < BaseController
    def update
      if current_user.update(password_params)
        redirect_to web_users_settings_profile_path, notice: "Your password has been updated."
      else
        render("web/user/settings/profile", status: :unprocessable_entity)
      end
    end

    private

    def password_params
      params.require(:user).permit(
        :password,
        :password_confirmation,
        :password_challenge
      ).with_defaults(password_challenge: "")
    end
  end
end
