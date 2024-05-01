# frozen_string_literal: true

class User::Token < ApplicationRecord
  belongs_to :user
  has_secure_token :access_token, length: 40
end
