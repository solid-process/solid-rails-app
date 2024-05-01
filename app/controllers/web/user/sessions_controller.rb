# frozen_string_literal: true

module Web::User
  class SessionsController < BaseController
    def destroy
      sign_out

      redirect_to new_web_guest_session_path, notice: "You have successfully signed out."
    end
  end
end
