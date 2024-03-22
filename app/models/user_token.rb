# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user

  before_validation :refresh_access_token, on: :create

  validates :access_token, presence: true, length: {is: 40}, uniqueness: true

  def refresh_access_token
    self.access_token = SecureRandom.hex(20)
  end

  def refresh_access_token!
    3.times do
      refresh_access_token.tap { save! }

      break if saved_change_to_access_token?
    end

    access_token
  end
end
