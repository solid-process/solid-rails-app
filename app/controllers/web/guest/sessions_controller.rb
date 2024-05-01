# frozen_string_literal: true

module Web::Guest
  class SessionsController < BaseController
    def new
      render("web/guest/sessions/new", locals: {user: ::User.new})
    end

    def create
      user = ::User.authenticate_by(email: user_params[:email], password: user_params[:password])

      if user
        sign_in(user)

        redirect_to web_task_items_path, notice: "You have successfully signed in!"
      else
        flash.now[:alert] = "Invalid email or password. Please try again."

        user = ::User.new(email: user_params[:email])

        render("web/guest/sessions/new", status: :unprocessable_entity, locals: {user:})
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
