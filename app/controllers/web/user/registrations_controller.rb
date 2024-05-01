# frozen_string_literal: true

module Web::User
  class RegistrationsController < BaseController
    def destroy
      current_user.destroy!

      redirect_to root_path, notice: "Your account has been deleted."
    end
  end
end
