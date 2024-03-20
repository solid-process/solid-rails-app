# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  helper_method def user_signed_in?
    current_user.present?
  end

  helper_method def current_user
    Current.user ||= User.find_by(id: current_user_id) if current_user_id.present?
  end

  def authenticate_user!
    return if current_user

    redirect_to web_guests_sign_in_path, notice: "You need to sign in or sign up before continuing."
  end

  def current_user_id
    session[:user_id]
  end

  def current_user_id=(id)
    session[:user_id] = id
  end

  def sign_in(user)
    Current.user = user

    reset_session

    self.current_user_id = user.id
  end

  def sign_out(user)
    Current.user = nil

    reset_session
  end
end
