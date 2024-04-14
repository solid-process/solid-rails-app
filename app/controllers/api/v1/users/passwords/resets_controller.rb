# frozen_string_literal: true

module API::V1
  class Users::Passwords::ResetsController < BaseController
    skip_before_action :authenticate_user!

    def create
      user = User.find_by(email: user_params[:email])

      if user
        UserMailer.with(
          user: user,
          token: user.generate_token_for(:reset_password)
        ).reset_password.deliver_later
      end

      render_json_with_success(status: :ok)
    end

    def update
      token = password_params.delete(:token)

      return render_invalid_token if token.blank?

      user = User.find_by_token_for(:reset_password, token)

      return render_invalid_token if user.nil?

      if user.update(password_params)
        render_json_with_success(status: :ok)
      else
        render_json_with_model_errors(user)
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end

    def password_params
      @password_params ||= params.require(:user).permit(:token, :password, :password_confirmation)
    end

    def render_invalid_token
      render_json_with_error(status: :unprocessable_entity, message: "Invalid token")
    end
  end
end
