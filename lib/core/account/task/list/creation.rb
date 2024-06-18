# frozen_string_literal: true

module Account::Task::List
  class Creation < Solid::Process
    deps do
      attribute :repository, default: -> { Adapters.repository }

      validates :repository, kind_of: Adapters::RepositoryInterface
    end

    input do
      attribute :name, :string
      attribute :inbox, :boolean, default: false
      attribute :account

      before_validation do
        self.name = inbox ? "Inbox" : name&.strip
      end

      validates :name, presence: true
      validates :account, instance_of: Account::Entity, is: :persisted?
    end

    def call(attributes)
      case deps.repository.create!(**attributes)
      in Solid::Success(task_list:)
        Success(:task_list_created, task_list:)
      in Solid::Failure
        Failure(:task_list_already_exists)
      end
    end
  end
end
