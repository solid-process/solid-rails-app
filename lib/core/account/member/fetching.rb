# frozen_string_literal: true

module Account::Member
  class Fetching < Solid::Process
    deps do
      attribute :repository, default: -> { Adapters.repository }

      validates :repository, kind_of: Adapters::RepositoryInterface
    end

    input do
      attribute :uuid
      attribute :account_id
      attribute :task_list_id
    end

    def call(attributes)
      case deps.repository.find_including_task_list(**attributes)
      in Solid::Success(member:) then Success(:member_found, member:)
      in Solid::Failure(member:)
        if member.errors.any?
          input.errors.merge!(member.errors)

          Failure(:invalid_input, input:)
        else
          Failure(:member_not_found, member:)
        end
      end
    end
  end
end
