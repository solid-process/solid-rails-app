# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships

  has_many :task_lists, through: :accounts
  has_many :tasks, through: :task_lists

  has_one :ownership, -> { owner }, class_name: "Membership", inverse_of: :user, dependent: nil
  has_one :account, through: :ownership
  has_one :inbox, through: :account
  has_one :token, class_name: "UserToken", dependent: :destroy

  generates_token_for :reset_password, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  generates_token_for :email_confirmation, expires_in: 24.hours do
    email
  end

  before_destroy prepend: true do
    account.destroy!
  end

  def self.find_by_reset_password(token:)
    find_by_token_for(:reset_password, token)
  end
end
