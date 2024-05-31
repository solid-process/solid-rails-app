# frozen_string_literal: true

module Account
  class Record < ApplicationRecord
    self.table_name = "accounts"

    with_options foreign_key: :account_id, inverse_of: :account do
      has_many :task_lists, dependent: :destroy, class_name: "Task::List::Record"

      has_many :memberships, dependent: :destroy, class_name: "Membership::Record"

      has_one :ownership, -> { owner }, dependent: nil, class_name: "Membership::Record"
    end

    has_many :task_items, through: :task_lists
    has_many :users, through: :memberships, class_name: "User::Record"

    has_one :inbox, -> { inbox }, inverse_of: :account, dependent: nil, class_name: "Task::List::Record"
    has_one :owner, through: :ownership, source: :user

    validates :uuid, presence: true
  end
end
