# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships

  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, uniqueness: true

  normalizes :email, with: -> { _1.strip.downcase }

  generates_token_for :reset_password, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  generates_token_for :email_confirmation, expires_in: 24.hours do
    email
  end
end
