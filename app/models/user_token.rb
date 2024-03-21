# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user

  before_create :refresh_access_token

  def refresh_access_token
    self.access_token = SecureRandom.hex(20)
  end

  def refresh_access_token!
    refresh_access_token.tap { save! }
  end
end
