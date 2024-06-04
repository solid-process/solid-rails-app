# frozen_string_literal: true

class User::Token::Record < ApplicationRecord
  self.table_name = "user_tokens"

  belongs_to :user, inverse_of: :token, class_name: "User::Record"
end
