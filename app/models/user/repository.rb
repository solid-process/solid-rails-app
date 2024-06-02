# frozen_string_literal: true

module User
  module Repository
    extend Solid::Output.mixin
    extend self

    def find_by(**attributes)
      user = Record.find_by(attributes)

      return Failure(:user_not_found) if user.nil?

      block_given? ? yield(user) : Success(:user_found, user:)
    end

    def exists?(**attributes)
      Record.exists?(attributes)
    end

    def create!(uuid:, email:, password:, password_confirmation:)
      user = Record.create(uuid:, email:, password:, password_confirmation:)

      user.persisted? ? Success(:user_created, user:) : Failure(:invalid_user, user:)
    end

    def create_account!(user:)
      account = Account::Record.create!(uuid: ::UUID.generate)

      member = Account::Member::Record.create!(uuid: user.uuid)

      account.memberships.create!(member:, role: :owner)

      Success(:account_created, account:)
    end

    def destroy_account!(user:)
      member = Account::Member::Record.find_by!(uuid: user.uuid)

      user.transaction do
        member.account.destroy!
        member.destroy!
        user.destroy!
      end

      Success(:account_deleted, user:, account: member.account)
    end

    def find_by_email_and_password(email:, password:)
      user = Record.authenticate_by(email:, password:)

      user ? Success(:user_found, user:) : Failure(:invalid_email_or_password)
    end

    def find_by_reset_password(token:)
      user = Record.find_by_token_for(:reset_password, token)

      user ? Success(:user_found, user:) : Failure(:invalid_or_expired_token)
    end

    def reset_password(token:, password:, password_confirmation:)
      case find_by_reset_password(token:)
      in Solid::Failure => failure then failure
      in Solid::Success(user:)
        if user.update(password:, password_confirmation:)
          Success(:password_updated, user:)
        else
          Failure(:invalid_user, user:)
        end
      end
    end

    def update_password(user:, password:, password_confirmation:, current_password:)
      if user.update(password:, password_confirmation:, password_challenge: current_password)
        Success(:password_updated, user:)
      else
        password_challenge_errors = user.errors.delete(:password_challenge)

        password_challenge_errors&.each { user.errors.add(:current_password, _1) }

        Failure(:invalid_password, user:)
      end
    end
  end
end
