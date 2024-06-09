# frozen_string_literal: true

module Web::User
  class PasswordsController < BaseController
    def update
      case User.update_password(user: current_user, **password_params)
      in Solid::Success
        redirect_to web_user_settings_profile_path, notice: "Your password has been updated."
      in Solid::Failure(input:)
        render("web/user/settings/profile", status: :unprocessable_entity, locals: {input:})
      end
    end

    def password_params
      params.require(:user).permit(
        :password,
        :password_confirmation,
        :current_password
      ).with_defaults(current_password: "")
    end
  end
end
