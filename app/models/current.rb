# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :account
  attribute :task_list
  attribute :membership
end
