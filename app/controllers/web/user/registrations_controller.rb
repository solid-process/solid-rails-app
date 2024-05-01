# frozen_string_literal: true

module Web::User
  class RegistrationsController < BaseController
    def destroy
      case User::AccountDeletion.call(user: current_user)
      in Solid::Success
        sign_out

        redirect_to(root_path, notice: "Your account has been deleted.")
      end
    end
  end
end
