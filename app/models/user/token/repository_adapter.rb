# frozen_string_literal: true

module User::Token
  module RepositoryAdapter
    extend Adapters::RepositoryInterface
    extend Solid::Output.mixin
    extend self

    def find_by_user(id:)
      short = Record.where(user_id: id).pick(:short)

      return Failure(:token_not_found) if short.nil?

      Success(:token_found, token: Entity.new(short:))
    end

    def create!(user:, token:)
      return Failure(:invalid_token, token:) if token.invalid?

      Record.create!(user_id: user.id, short: token.short.value, checksum: token.checksum)

      Success(:token_created, token:)
    end

    def refresh(user:, token:)
      return Failure(:invalid_token, token:) if token.invalid?

      record = Record.find_by(user_id: user.id)

      record.update!(short: token.short.value, checksum: token.checksum)

      Success(:token_refreshed, token:)
    rescue ::ActiveRecord::RecordNotUnique => e
      Failure(:cannot_be_refreshed, token:, error: e)
    end
  end
end
