# frozen_string_literal: true

class Account::Task::List::Creation < Solid::Process
  input do
    attribute :name, :string
    attribute :inbox, :boolean, default: false
    attribute :account

    before_validation do
      self.name = inbox ? "Inbox" : name&.strip
    end

    validates :name, presence: true
    validates :account, instance_of: [Account, Account::Member], is: :persisted?
  end

  def call(attributes)
    Given(attributes)
      .and_then(:fetch_task_lists_relation)
      .and_then(:validate_uniqueness_if_inbox)
      .and_then(:create_task_list)
      .and_expose(:task_list_created, [:task_list])
  end

  private

  def fetch_task_lists_relation(account:, **)
    Continue(task_lists: account.task_lists)
  end

  def validate_uniqueness_if_inbox(task_lists:, inbox:, **)
    (inbox && task_lists.inbox.exists?) ? Failure(:inbox_already_exists) : Continue()
  end

  def create_task_list(task_lists:, name:, inbox:, **)
    task_list = task_lists.create!(name:, inbox:)

    Continue(task_list:)
  end
end
