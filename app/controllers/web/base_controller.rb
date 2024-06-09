# frozen_string_literal: true

class Web::BaseController < ApplicationController
  rescue_from ActionController::InvalidAuthenticityToken do
    render "web/errors/bad_request", status: :bad_request, layout: "web/errors"
  end

  private

  helper_method def user_signed_in?
    current_user.present?
  end

  helper_method def current_user
    @current_user ||= User.repository.find_by(uuid: current_user_uuid).fetch(:user, nil)
  end

  helper_method def current_task_list
    current_member.task_list
  end

  helper_method def current_task_list?(task_list)
    current_member.task_list_id == task_list.id
  end

  def authenticate_user!
    return if current_user.present?

    redirect_to new_web_guest_session_path, alert: "You need to sign in or sign up before continuing."
  end

  def current_member
    @current_member ||=
      Account.member.find_by(uuid: current_user.uuid, task_list_id: current_task_list_id).fetch(:member)
  end

  def current_user_uuid=(id)
    session[:user_uuid] = id
  end

  def current_user_uuid
    session[:user_uuid]
  end

  def current_task_list_id=(id)
    session[:task_list_id] = id
  end

  def current_task_list_id
    session[:task_list_id]
  end

  def sign_in(user)
    reset_session

    self.current_user_uuid = user.uuid
  end

  def sign_out
    reset_session
  end

  def render_not_found_error
    render "web/errors/not_found", status: :not_found, layout: "web/errors"
  end

  def render_unprocessable_entity_error
    render("web/errors/unprocessable_entity", status: :unprocessable_entity, layout: "web/errors")
  end
end
