# frozen_string_literal: true

module Account::Task::List
  class Listing < Solid::Process
    deps do
      attribute :repository, default: Repository

      validates :repository, respond_to: [:list_by]
    end

    input do
      attribute :account

      validates :account, instance_of: [Account::Record, Account::Member], is: :persisted?
    end

    def call(attributes)
      relation = deps.repository.list_by(**attributes)

      Success(:task_lists_found, relation:)
    end
  end
end
