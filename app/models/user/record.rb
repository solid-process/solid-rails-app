# frozen_string_literal: true

module User
  class Record < ApplicationRecord
    self.table_name = "users"

    has_secure_password

    with_options foreign_key: :user_id, inverse_of: :user do
      has_many :memberships, dependent: :destroy, class_name: "Account::Membership::Record"

      has_one :ownership, -> { owner }, dependent: nil, class_name: "Account::Membership::Record"

      has_one :token, dependent: :destroy, class_name: "Token::Record"
    end

    has_many :accounts, through: :memberships
    has_many :task_lists, through: :accounts, class_name: "Account::Task::List::Record"
    has_many :task_items, through: :task_lists, class_name: "Account::Task::Item::Record"

    has_one :account, through: :ownership
    has_one :inbox, through: :account, class_name: "Account::Task::List::Record"

    generates_token_for :reset_password, expires_in: 15.minutes do
      password_salt&.last(10)
    end

    generates_token_for :email_confirmation, expires_in: 24.hours do
      email
    end
  end
end
