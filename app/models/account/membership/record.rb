# frozen_string_literal: true

module Account::Membership
  class Record < ApplicationRecord
    self.table_name = "memberships"

    belongs_to :user, class_name: "User::Record"
    belongs_to :account, class_name: "Account::Record"

    enum role: {owner: "owner"}
  end
end
