# frozen_string_literal: true

module Account::Task
  module Item::Adapters::RepositoryInterface
    include Solid::Adapters::Interface

    module Methods
      ARRAY_OF_ENTITIES = -> { _1.is_a?(Array) && _1.all?(Item::Entity) }

      def list_by(filter:, task_list:)
        filter => String | nil
        task_list => List::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found, {}) |
            Solid::Success(:tasks_found, {tasks: ARRAY_OF_ENTITIES})
          )
        end
      end

      def find_by(id:, task_list:)
        id => Integer | String
        task_list => List::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :task_not_found, {}) |
            Solid::Success(Symbol, {task: Item::Entity})
          )
        end
      end

      def create!(name:, task_list:)
        name => String
        task_list => List::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found, {}) |
            Solid::Success(:task_created, {task: Item::Entity})
          )
        end
      end

      def update!(id:, task_list:, **new_attributes)
        id => Integer | String
        task_list => List::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :task_not_found, {}) |
            Solid::Failure(:invalid_task, {task: Item::Entity}) |
            Solid::Success(:task_updated, {task: Item::Entity})
          )
        end
      end

      def complete!(id:, task_list:)
        id => Integer | String
        task_list => List::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :task_not_found, {}) |
            Solid::Success(:task_completed, {task: Item::Entity})
          )
        end
      end

      def incomplete!(id:, task_list:)
        id => Integer | String
        task_list => List::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :task_not_found, {}) |
            Solid::Success(:task_incomplete, {task: Item::Entity})
          )
        end
      end

      def delete!(id:, task_list:)
        id => Integer | String
        task_list => List::Entity

        super.tap do
          _1 => (
            Solid::Failure(:task_list_not_found | :task_not_found, {}) |
            Solid::Success(:task_deleted, {task: Item::Entity})
          )
        end
      end
    end
  end
end
