module Web::Guest
  class RegistrationsController < BaseController
    def new
      render("web/guest/registrations/new", locals: {user: ::User.new})
    end

    def create
      user = ::User.new(registrations_params)

      if user.save
        sign_in(user)

        redirect_to web_task_items_path, notice: "You have successfully registered!"
      else
        render("web/guest/registrations/new", locals: {user:}, status: :unprocessable_entity)
      end
    end

    private

    def registrations_params
      params.require(:guest).permit(:email, :password, :password_confirmation)
    end
  end
end
