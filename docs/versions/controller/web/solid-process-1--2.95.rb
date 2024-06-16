module Web::Guest
  class RegistrationsController < BaseController
    def new
      render("web/guest/registrations/new", locals: {user: ::User::Registration::Input.new})
    end

    def create
      case ::User::Registration.call(registrations_params)
      in Solid::Success(user:)
        sign_in(user)

        redirect_to web_task_items_path, notice: "You have successfully registered!"
      in Solid::Failure(input:)
        render("web/guest/registrations/new", locals: {user: input}, status: :unprocessable_entity)
      end
    end

    private

    def registrations_params
      params.require(:guest).permit(:email, :password, :password_confirmation)
    end
  end
end
