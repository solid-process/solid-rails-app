# frozen_string_literal: true

module User
  module TemporaryToken
    extend self

    def to(purpose, user)
      user.persisted? or raise ::ArgumentError, "User must be persisted"

      user_data = (purpose == :reset_password) ? password_salt(user) : user

      Record.token_definitions.fetch(purpose).generate_token(user_data)
    end

    private

    PasswordSalt = ::Data.define(:id, :password_salt)

    def password_salt(user)
      id, password_digest = Record.where(id: user.id).pick(:id, :password_digest)

      PasswordSalt[id, ::BCrypt::Password.new(password_digest).salt]
    end
  end
end
