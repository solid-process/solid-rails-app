# frozen_string_literal: true

module API::V1
  class Users::RegistrationsController < BaseController
    skip_before_action :authenticate_user!, only: [:create]

    def create
      case User::Registration.call(user_params)
      in Solid::Success(user:)
        render_json_with_success(status: :created, data: {access_token: user.token.access_token})
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      end
    end

    def destroy
      result = User::AccountDeletion.call(user: current_user)

      result.account_deleted? and return render_json_with_success(status: :ok)
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
