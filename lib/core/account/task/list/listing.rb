# frozen_string_literal: true

module Account::Task::List
  class Listing < Solid::Process
    deps do
      attribute :repository, default: -> { Adapters.repository }

      validates :repository, respond_to: [:list_by]
    end

    input do
      attribute :account

      validates :account, instance_of: Account::Entity, is: :persisted?
    end

    def call(attributes)
      relation = deps.repository.list_by(**attributes)

      Success(:task_lists_found, relation:)
    end
  end
end
