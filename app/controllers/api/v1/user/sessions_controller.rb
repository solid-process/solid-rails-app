# frozen_string_literal: true

module API::V1
  class User::SessionsController < BaseController
    skip_before_action :authenticate_user!

    def create
      user = ::User.authenticate_by(email: user_params[:email], password: user_params[:password])

      if user
        render_json_with_success(status: :ok, data: {user_token: user.token.value})
      else
        render_json_with_error(status: :unauthorized, message: "Invalid email or password. Please try again.")
      end
    end

    private

    def user_params
      @user_params ||= params.require(:user).permit(:email, :password)
    end
  end
end
