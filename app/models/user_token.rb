# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user
  has_secure_token :access_token
end
