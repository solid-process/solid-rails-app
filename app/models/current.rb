# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :membership

  delegate :account, to: :membership, allow_nil: true
  delegate :user, to: :membership, allow_nil: true
end
