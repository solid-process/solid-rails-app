# frozen_string_literal: true

module User
  class Record < ApplicationRecord
    self.table_name = "users"

    has_secure_password

    with_options foreign_key: :user_id do
      has_one :token, dependent: :destroy, inverse_of: :user, class_name: "Token::Record"
    end

    generates_token_for :reset_password, expires_in: 15.minutes do
      password_salt&.last(10)
    end

    generates_token_for :email_confirmation, expires_in: 24.hours do
      email
    end
  end
end
