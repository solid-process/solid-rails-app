# frozen_string_literal: true

class Web::BaseController < ApplicationController
  helper_method :current_user
  helper_method :user_signed_in?

  helper_method :current_task_list
  helper_method :current_task_list?

  private

  def authenticate_user!
    if (membership = Membership.find_by(user_id: session[:user_id], account: accounts_for_authentication))
      Current.membership = membership
    else
      redirect_to new_web_guests_session_path, alert: "You need to sign in or sign up before continuing."
    end
  end

  def accounts_for_authentication
    if session[:task_list_id]
      Account.joins(:task_lists).where(task_lists: {id: session[:task_list_id]})
    else
      Account.joins(:task_lists).where(task_lists: {inbox: true})
    end
  end

  def current_user
    Current.user
  end

  def user_signed_in?
    Current.user.present?
  end

  def current_task_list
    if session[:task_list_id]
      Current.account.task_lists.find(session[:task_list_id])
    else
      Current.account.task_lists.first
    end
  end

  def current_task_list_id=(id)
    session[:task_list_id] = id
  end

  def current_task_list?(task_list)
    current_task_list == task_list
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    reset_session
  end
end
