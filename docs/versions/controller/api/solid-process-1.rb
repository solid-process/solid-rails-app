module API::V1
  class User::RegistrationsController < BaseController
    skip_before_action :authenticate_user!, only: [:create]

    def create
      case ::User::Registration.call(user_params)
      in Solid::Success(user:)
        render_json_with_success(status: :created, data: {user_token: user.token.value})
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      end
    end

    def destroy
      current_user.destroy!

      render_json_with_success(status: :ok)
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
