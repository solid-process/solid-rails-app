# frozen_string_literal: true

module User::Adapters::RepositoryInterface
  include Solid::Adapters::Interface

  module Methods
    def find_by(**attributes)
      super.tap do
        _1 => (
          Solid::Failure(:user_not_found, {}) |
          Solid::Success(:user_found, {user: User::Entity})
        )
      end
    end

    def exists?(**attributes)
      super.tap { _1 => true | false }
    end

    def create!(uuid:, email:, password:, password_confirmation:)
      uuid => String
      email => String
      password => String
      password_confirmation => String

      super.tap do
        _1 => (
          Solid::Failure(:invalid_user, {user: User::Entity}) |
          Solid::Success(:user_created, {user: User::Entity})
        )
      end
    end

    def destroy!(user:)
      user => User::Entity

      super.tap { _1 => Solid::Success(:user_deleted, {user: User::Entity}) }
    end

    def fetch_by_token(value)
      value => String

      super.tap do
        _1 => (
          Solid::Failure(:invalid_token, {}) |
          Solid::Success(:user_found, {user: User::Entity})
        )
      end
    end

    def find_by_email_and_password(email:, password:)
      email => String
      password => String

      super.tap do
        _1 => (
          Solid::Failure(:invalid_email_or_password, {}) |
          Solid::Success(:user_found, {user: User::Entity})
        )
      end
    end

    def find_by_reset_password(token:)
      token => String

      super.tap do
        _1 => (
          Solid::Failure(:invalid_or_expired_token, {}) |
          Solid::Success(:user_found, {user: User::Entity})
        )
      end
    end

    def reset_password(token:, password:, password_confirmation:)
      token => String
      password => String
      password_confirmation => String

      super.tap do
        _1 => (
          Solid::Failure(:invalid_user, {user: User::Entity}) |
          Solid::Failure(:invalid_or_expired_token, {}) |
          Solid::Success(:password_updated, {user: User::Entity})
        )
      end
    end

    def update_password(user:, password:, password_confirmation:, current_password:)
      user => User::Entity
      password => String
      password_confirmation => String
      current_password => String

      super.tap do
        _1 => (
          Solid::Failure(:invalid_password, {user: User::Entity}) |
          Solid::Success(:password_updated, {user: User::Entity})
        )
      end
    end
  end
end
