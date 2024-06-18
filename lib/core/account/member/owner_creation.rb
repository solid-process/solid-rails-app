# frozen_string_literal: true

module Account::Member
  class OwnerCreation < Solid::Process
    deps do
      attribute :repository, default: -> { Adapters.repository }

      attribute :task_list_creation, default: Account::Task::List::Creation

      validates :repository, kind_of: Adapters::RepositoryInterface
    end

    input do
      attribute :uuid, :string

      validates :uuid, presence: true, format: ::UUID::REGEXP
    end

    def call(attributes)
      rollback_on_failure {
        Given(attributes)
          .and_then(:create_member)
          .and_then(:create_owner_account)
          .and_then(:create_account_inbox)
      }
        .and_expose(:owner_created, [:member])
    end

    private

    def create_member(uuid:)
      result = deps.repository.create!(uuid:)

      Continue(member: result.fetch(:member))
    end

    def create_owner_account(member:, **)
      result = deps.repository.create_account!(member:, uuid: member.uuid)

      Continue(account: result.fetch(:account))
    end

    def create_account_inbox(account:, **)
      case deps.task_list_creation.call(account:, inbox: true)
      in Solid::Success then Continue()
      end
    end
  end
end
