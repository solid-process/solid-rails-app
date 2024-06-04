# frozen_string_literal: true

module Account::Task
  class Item::Listing < Solid::Process
    deps do
      attribute :repository, default: -> { Item::Adapters.repository }

      validates :repository, respond_to: [:list_by]
    end

    input do
      attribute :filter, default: "all"
      attribute :task_list

      validates :task_list, instance_of: List::Entity
    end

    def call(attributes)
      case deps.repository.list_by(**attributes)
      in Solid::Failure(:task_list_not_found, _)
        Failure(:task_list_not_found)
      in Solid::Success(tasks:)
        Success(:tasks_found, tasks:)
      end
    end
  end
end
