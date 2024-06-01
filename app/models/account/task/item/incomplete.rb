# frozen_string_literal: true

module Account::Task::Item
  class Incomplete < Solid::Process
    deps do
      attribute :repository, default: Repository

      validates :repository, respond_to: [:incomplete!]
    end

    input do
      attribute :id, :integer
      attribute :member

      validates :id, numericality: {only_integer: true, greater_than: 0}
      validates :member, instance_of: Account::Member
    end

    def call(attributes)
      case deps.repository.incomplete!(**attributes)
      in Solid::Failure(:task_list_not_found, _) then Failure(:task_list_not_found)
      in Solid::Failure(:task_not_found, _) then Failure(:task_not_found)
      in Solid::Success(task:) then Success(:task_incomplete, task:)
      end
    end
  end
end
