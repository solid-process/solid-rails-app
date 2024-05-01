# frozen_string_literal: true

class Account::Task::List::Listing < Solid::Process
  input do
    attribute :account

    validates :account, instance_of: [Account, Account::Member], is: :persisted?
  end

  def call(attributes)
    attributes => {account:}

    relation = account.task_lists.order(created_at: :desc)

    Success(:records_found, relation:)
  end
end
