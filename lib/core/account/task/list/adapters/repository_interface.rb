# frozen_string_literal: true

module Account::Task::List
  module Adapters::RepositoryInterface
    include Solid::Adapters::Interface

    module Methods
      ARRAY_OF_ENTITIES = -> { _1.is_a?(Array) && _1.all?(Entity) }

      def list_by(account:)
        account => Account::Entity

        super.tap { _1 => ARRAY_OF_ENTITIES }
      end

      def find_by(id:, account:)
        id => Integer | String
        account => Account::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :inbox_cannot_be_edited, {}) |
            Solid::Success(Symbol, {task_list: Entity})
          )
        end
      end

      def create!(name:, inbox:, account:)
        name => String
        inbox => true | false
        account => Account::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_already_exists, {}) |
            Solid::Success(:task_list_created, {task_list: Entity})
          )
        end
      end

      def update!(id:, name:, account:)
        id => Integer | String
        name => String
        account => Account::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :inbox_cannot_be_edited, {}) |
            Solid::Success(:task_list_updated, {task_list: Entity})
          )
        end
      end

      def destroy!(id:, account:)
        id => Integer | String
        account => Account::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :inbox_cannot_be_edited, {}) |
            Solid::Success(:task_list_deleted, {task_list: Entity})
          )
        end
      end
    end
  end
end
