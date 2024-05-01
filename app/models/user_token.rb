# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user

  def value
    User::Token::Entity.new(short:).value
  end
end
