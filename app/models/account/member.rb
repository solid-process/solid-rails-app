# frozen_string_literal: true

module Account::Member
  extend Solid::Context

  self.actions = {
    find_by: Fetching
  }
end
