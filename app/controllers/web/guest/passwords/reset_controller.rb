# frozen_string_literal: true

module Web::Guest
  class Passwords::ResetController < BaseController
    def edit
      token = params[:token]

      case User.repository.find_by_reset_password(token:)
      in Solid::Failure
        invalid_or_expired_token
      in Solid::Success
        input = User.reset_password.input.new(token:)

        render("web/guest/passwords/reset", locals: {user: input})
      end
    end

    def update
      case User.reset_password(token: params[:token], **password_params)
      in Solid::Success
        redirect_to new_web_guest_session_path, notice: "Your password has been reset successfully. Please sign in."
      in Solid::Failure(:user_not_found, _)
        redirect_to new_web_guest_password_path, alert: "Invalid or expired token."
      in Solid::Failure(input:)
        render("web/guest/passwords/reset", status: :unprocessable_entity, locals: {user: input})
      end
    end

    private

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def invalid_or_expired_token
      redirect_to new_web_guest_password_path, alert: "Invalid or expired token."
    end
  end
end
