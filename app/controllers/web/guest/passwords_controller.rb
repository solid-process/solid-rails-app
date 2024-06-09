# frozen_string_literal: true

module Web::Guest
  class PasswordsController < BaseController
    def new
      render("web/guest/passwords/new", locals: {user: ::User.send_reset_password_instructions.input.new})
    end

    def create
      user_params = params.require(:user).permit(:email)

      ::User.send_reset_password_instructions(user_params)

      redirect_to new_web_guest_session_path, notice: "Check your email to reset your password."
    end
  end
end
