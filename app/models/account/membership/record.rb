# frozen_string_literal: true

module Account::Membership
  class Record < ApplicationRecord
    self.table_name = "memberships"

    belongs_to :member, class_name: "Account::Member::Record"
    belongs_to :account, class_name: "Account::Record"

    enum role: {owner: "owner"}
  end
end
