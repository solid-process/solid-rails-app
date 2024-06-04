# frozen_string_literal: true

module Account::Task::List
  class Deletion < Solid::Process
    deps do
      attribute :repository, default: Repository

      validates :repository, respond_to: [:destroy!]
    end

    input do
      attribute :id, :integer
      attribute :account

      validates :id, numericality: {only_integer: true, greater_than: 0}
      validates :account, instance_of: Account::Entity
    end

    def call(attributes)
      case deps.repository.destroy!(**attributes)
      in Solid::Failure(:task_list_not_found, _) then Failure(:task_list_not_found)
      in Solid::Failure(:inbox_cannot_be_edited, _) then Failure(:inbox_cannot_be_edited)
      in Solid::Success(task_list:)
        Success(:task_list_deleted, task_list:)
      end
    end
  end
end
