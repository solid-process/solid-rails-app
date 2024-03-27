# frozen_string_literal: true

class Web::BaseController < ApplicationController
  rescue_from ActionController::InvalidAuthenticityToken do
    render "web/errors/bad_request", status: :bad_request, layout: "web/errors"
  end

  rescue_from ActiveRecord::RecordNotFound do
    render "web/errors/not_found", status: :not_found, layout: "web/errors"
  end

  private

  helper_method def user_signed_in?
    current_user.present?
  end

  helper_method def current_user
    Current.user ||= authenticate_user_from_session&.user
  end

  helper_method def current_task_list
    Current.task_list ||= authenticate_user_from_session&.task_list
  end

  helper_method def current_task_list?(task_list)
    current_task_list_id == task_list.id
  end

  def authenticate_user_from_session
    return unless current_user_id?

    task_lists = current_task_list_id? ? {id: current_task_list_id} : {inbox: true}

    memberships = Membership.where(user_id: current_user_id, task_lists:)

    membership = memberships.includes(:user, account: :task_lists).first

    user, account = membership&.values_at(:user, :account)

    Current.user = user
    Current.account = account
    Current.task_list = account&.task_lists&.first
    Current.membership = membership

    self.current_task_list_id = Current.task_list.id unless current_task_list_id?

    Current
  end

  def authenticate_user!
    return if current_user

    redirect_to new_web_guests_session_path, alert: "You need to sign in or sign up before continuing."
  end

  def current_user_id=(id)
    session[:user_id] = id
  end

  def current_user_id
    session[:user_id]
  end

  def current_user_id?
    current_user_id.present?
  end

  def current_task_list_id=(id)
    session[:task_list_id] = id
  end

  def current_task_list_id
    session[:task_list_id]
  end

  def current_task_list_id?
    current_task_list_id.present?
  end

  def sign_in(user)
    Current.reset

    reset_session

    self.current_user_id = user.id
  end

  def sign_out
    Current.reset

    reset_session
  end
end
