# frozen_string_literal: true

module Account::Member
  class Deletion < Solid::Process
    deps do
      attribute :repository, default: -> { Adapters.repository }

      validates :repository, kind_of: Adapters::RepositoryInterface
    end

    input do
      attribute :uuid, :string

      validates :uuid, presence: true, format: ::UUID::REGEXP
    end

    def call(attributes)
      result = deps.repository.destroy_account!(**attributes)

      member, account = result.fetch_values(:member, :account)

      Success(:member_deleted, member:, account:)
    end
  end
end
