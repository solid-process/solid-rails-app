# frozen_string_literal: true

class User < ApplicationRecord
  include AccountSetup
  include Authentication

  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships

  has_many :task_lists, through: :accounts
  has_many :tasks, through: :task_lists

  has_one :ownership, -> { owner }, class_name: "Membership", inverse_of: :user, dependent: nil
  has_one :account, through: :ownership
  has_one :inbox, through: :account

  has_one :token, class_name: "UserToken", dependent: :destroy

  validates :password, allow_nil: true, length: {minimum: 8}
  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  normalizes :email, with: -> { _1.strip.downcase }
end
