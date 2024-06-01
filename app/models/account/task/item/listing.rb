# frozen_string_literal: true

module Account::Task::Item
  class Listing < Solid::Process
    deps do
      attribute :repository, default: Repository

      validates :repository, respond_to: [:list_by]
    end

    input do
      attribute :member
      attribute :filter, default: "all"

      validates :member, instance_of: Account::Member
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
