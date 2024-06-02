# frozen_string_literal: true

class Account::Member::Record < ApplicationRecord
  self.table_name = "account_members"

  with_options foreign_key: :member_id, inverse_of: :member do
    has_many :memberships, dependent: :destroy, class_name: "Account::Membership::Record"

    has_one :ownership, -> { owner }, dependent: nil, class_name: "Account::Membership::Record"
  end

  has_many :accounts, through: :memberships
  has_many :task_lists, through: :accounts, class_name: "Account::Task::List::Record"
  has_many :task_items, through: :task_lists, class_name: "Account::Task::Item::Record"

  has_one :account, through: :ownership
  has_one :inbox, through: :account, class_name: "Account::Task::List::Record"
end
