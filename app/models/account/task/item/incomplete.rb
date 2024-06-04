# frozen_string_literal: true

module Account::Task
  class Item::Incomplete < Solid::Process
    deps do
      attribute :repository, default: Item::Repository

      validates :repository, respond_to: [:incomplete!]
    end

    input do
      attribute :id, :integer
      attribute :task_list

      validates :id, numericality: {only_integer: true, greater_than: 0}
      validates :task_list, instance_of: List::Entity
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
