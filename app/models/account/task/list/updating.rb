# frozen_string_literal: true

module Account::Task::List
  class Updating < Solid::Process
    deps do
      attribute :repository, default: Repository

      validates :repository, respond_to: [:update!]
    end

    input do
      attribute :id, :integer
      attribute :name, :string
      attribute :account

      before_validation do
        self.name = name&.strip
      end

      validates :id, numericality: {only_integer: true, greater_than: 0}
      validates :name, presence: true
      validates :account, instance_of: [Account::Record, Account::Member]
    end

    def call(attributes)
      case deps.repository.update!(**attributes)
      in Solid::Failure(:task_list_not_found, _) then Failure(:task_list_not_found)
      in Solid::Failure(:inbox_cannot_be_edited, _) then Failure(:inbox_cannot_be_edited)
      in Solid::Success(task_list:)
        Success(:task_list_updated, task_list:)
      end
    end
  end
end
