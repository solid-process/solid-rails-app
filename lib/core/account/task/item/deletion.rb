# frozen_string_literal: true

module Account::Task
  class Item::Deletion < Solid::Process
    deps do
      attribute :repository, default: -> { Item::Adapters.repository }

      validates :repository, respond_to: [:delete!]
    end

    input do
      attribute :id, :integer
      attribute :task_list

      validates :id, numericality: {only_integer: true, greater_than: 0}
      validates :task_list, instance_of: List::Entity
    end

    def call(attributes)
      case deps.repository.delete!(**attributes)
      in Solid::Failure(:task_list_not_found, _) then Failure(:task_list_not_found)
      in Solid::Failure(:task_not_found, _) then Failure(:task_not_found)
      in Solid::Success(task:) then Success(:task_deleted, task:)
      end
    end
  end
end
