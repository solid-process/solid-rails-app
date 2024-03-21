# frozen_string_literal: true

module Web::Guests
  class RegistrationsController < BaseController
    def new
      render_new(user: User.new, status: :ok)
    end

    def create
      user = User.new(registrations_params)

      if user.save
        sign_in(user)

        redirect_to web_tasks_path, notice: "You have successfully registered!"
      else
        render("web/guest/registrations/new", locals: {user:}, status: :unprocessable_entity)
      end
    end

    private

    def registrations_params
      params.require(:guest).permit(:email, :password, :password_confirmation)
    end

    def render_new(user:, status: :ok)
      render("web/guest/registrations/new", status:, locals: {user: user})
    end
  end
end
