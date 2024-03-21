# frozen_string_literal: true

module Web::Users
  class RegistrationsController < BaseController
    def destroy
      current_user.transaction do
        current_user.account.destroy!
        current_user.destroy!
      end

      redirect_to root_path, notice: "Your account has been deleted"
    end
  end
end
