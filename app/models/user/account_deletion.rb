# frozen_string_literal: true

class User::AccountDeletion < Solid::Process
  deps do
    attribute :repository, default: User::Repository

    attribute :account_deletion, default: Account::Member::Deletion

    validates :repository, respond_to: [:destroy!]
  end

  input do
    attribute :user

    validates :user, instance_of: User::Entity, is: :persisted?
  end

  def call(attributes)
    rollback_on_failure do
      Given(attributes)
        .and_then(:delete_account)
        .and_then(:delete_user)
    end
      .and_expose(:account_deleted, [:user, :account])
  end

  private

  def delete_account(user:)
    result = deps.account_deletion.call(uuid: user.uuid)

    Continue(account: result.fetch(:account))
  end

  def delete_user(user:, **)
    deps.repository.destroy!(user:)

    Continue()
  end
end
