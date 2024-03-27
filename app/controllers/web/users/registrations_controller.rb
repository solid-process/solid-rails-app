# frozen_string_literal: true

module Web::Users
  class RegistrationsController < BaseController
    layout "web/guest"

    skip_before_action :authenticate_user!, only: [:create]

    def create
      case User::Registration.call(registrations_params)
      in Solid::Success(user:)
        sign_in(user)

        redirect_to web_tasks_path, notice: "You have successfully registered!"
      in Solid::Failure(input:)
        render("web/guest/registrations/new", locals: {user: input}, status: :unprocessable_entity)
      end
    end

    def destroy
      current_user.destroy!

      redirect_to root_path, notice: "Your account has been deleted."
    end

    private

    def registrations_params
      params.require(:guest).permit(:email, :password, :password_confirmation)
    end
  end
end
