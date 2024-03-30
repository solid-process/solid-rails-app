module User::AccountSetup
  extend ActiveSupport::Concern

  included do
    after_create :setup_account
    after_create :create_token!
  end

  private

  def setup_account
    account = Account.create!
    account.memberships.create!(user: self, role: :owner)
    account.task_lists.inbox.create!
  end
end
