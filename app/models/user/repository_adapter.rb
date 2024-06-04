# frozen_string_literal: true

module User
  module RepositoryAdapter
    extend Solid::Output.mixin
    extend self

    def find_by(**attributes)
      record = Record.find_by(attributes)

      return Failure(:user_not_found) if record.nil?

      block_given? ? yield(record) : Success(:user_found, user: entity(record))
    end

    def exists?(**attributes)
      Record.exists?(attributes)
    end

    def create!(uuid:, email:, password:, password_confirmation:)
      record = Record.create(uuid:, email:, password:, password_confirmation:)

      user = entity(record)

      record.persisted? ? Success(:user_created, user:) : Failure(:invalid_user, user:)
    end

    def destroy!(user:)
      Record.find(user.id).destroy!

      Success(:user_deleted, user:)
    end

    def fetch_by_token(value)
      short, checksum = Token::Entity.parse(value).values_at(:short, :checksum)

      record = Record.joins(:token).find_by(user_tokens: {short: short.value, checksum:})

      record ? Success(:user_found, user: entity(record)) : Failure(:invalid_token)
    end

    def find_by_email_and_password(email:, password:)
      record = Record.authenticate_by(email:, password:)

      record ? Success(:user_found, user: entity(record)) : Failure(:invalid_email_or_password)
    end

    def find_by_reset_password(token:)
      find_by_reset_password!(token) { Success(:user_found, user: entity(_1)) }
    end

    def reset_password(token:, password:, password_confirmation:)
      find_by_reset_password!(token) do |record|
        if record.update(password:, password_confirmation:)
          Success(:password_updated, user: entity(record))
        else
          Failure(:invalid_user, user: entity(record))
        end
      end
    end

    def update_password(user:, password:, password_confirmation:, current_password:)
      record = Record.find(user.id)

      if record.update(password:, password_confirmation:, password_challenge: current_password)
        Success(:password_updated, user:)
      else
        password_challenge_errors = record.errors.delete(:password_challenge)

        password_challenge_errors&.each { user.errors.add(:current_password, _1) }

        Failure(:invalid_password, user:)
      end
    end

    private

    def entity(record)
      Entity
        .new(id: record.id, uuid: record.uuid, email: record.email)
        .tap { _1.errors.merge!(record.errors) if record.errors.any? }
    end

    def find_by_reset_password!(token)
      record = Record.find_by_token_for(:reset_password, token)

      record ? yield(record) : Failure(:invalid_or_expired_token)
    end
  end
end
