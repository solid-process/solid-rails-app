# frozen_string_literal: true

module Account::Member
  module Adapters::RepositoryInterface
    include Solid::Adapters::Interface

    module Methods
      def create!(uuid:)
        uuid => String

        super.tap do
          _1 => (
            Solid::Failure(:uuid_has_already_been_taken, {}) |
            Solid::Success(:member_created, {member: Entity})
          )
        end
      end

      def create_account!(member:, uuid:)
        member => Entity
        uuid => String

        super.tap do
          _1 => (
            Solid::Failure(:uuid_has_already_been_taken, {}) |
            Solid::Success(:account_created, {account: Account::Entity})
          )
        end
      end

      def destroy_account!(uuid:)
        uuid => String

        super.tap do
          _1 => Solid::Success(:member_deleted, {member: Entity, account: Account::Entity})
        end
      end

      def find_including_task_list(uuid:, account_id:, task_list_id:)
        uuid => String
        account_id => Integer | String | nil
        task_list_id => Integer | String | nil

        super.tap do
          _1 => (
            Solid::Failure(:invalid_member | :member_not_found, {member: Entity}) |
            Solid::Success(:member_found, {member: Entity})
          )
        end
      end
    end
  end
end
