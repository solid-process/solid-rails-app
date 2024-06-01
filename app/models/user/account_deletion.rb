# frozen_string_literal: true

class User::AccountDeletion < Solid::Process
  deps do
    attribute :repository, default: User::Repository

    validates :repository, respond_to: [:destroy_account!]
  end

  input do
    attribute :user

    validates :user, instance_of: User::Record, is: :persisted?
  end

  def call(attributes)
    result = deps.repository.destroy_account!(**attributes)

    user, account = result.values_at(:user, :account)

    Success(:account_deleted, user:, account:)
  end
end
