# frozen_string_literal: true

module Web::Guest
  class SessionsController < BaseController
    def new
      render("web/guest/sessions/new", locals: {user: User::Authentication::Input.new})
    end

    def create
      case User::Authentication.call(user_params)
      in Solid::Success(user:)
        sign_in(user)

        redirect_to web_task_items_path, notice: "You have successfully signed in!"
      in Solid::Failure(input:)
        flash.now[:alert] = "Invalid email or password. Please try again."

        render("web/guest/sessions/new", status: :unprocessable_entity, locals: {user: input})
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
