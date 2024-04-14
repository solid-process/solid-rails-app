# frozen_string_literal: true

class User::AccountDeletion < Solid::Process
  input do
    attribute :user

    validates :user, instance_of: User, persisted: true
  end

  def call(_)
    user = input.user

    user.transaction do
      user.account.destroy!
      user.destroy!
    end

    Success(:account_deleted, user:, account: user.account)
  end
end
