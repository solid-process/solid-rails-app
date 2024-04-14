# frozen_string_literal: true

module Web::Users
  class SessionsController < BaseController
    layout "web/guest"

    skip_before_action :authenticate_user!, only: [:create]

    def create
      case User::Authentication.call(user_params)
      in Solid::Success(user:)
        sign_in(user)

        redirect_to web_tasks_path, notice: "You have successfully signed in!"
      in Solid::Failure(input:)
        flash.now[:alert] = "Invalid email or password. Please try again."

        render("web/guest/sessions/new", status: :unprocessable_entity, locals: {user: input})
      end
    end

    def destroy
      sign_out

      redirect_to new_web_guests_session_path, notice: "You have successfully signed out."
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
