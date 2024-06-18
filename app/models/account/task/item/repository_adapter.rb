# frozen_string_literal: true

module Account::Task
  module Item::RepositoryAdapter
    extend Item::Adapters::RepositoryInterface
    extend Solid::Output.mixin
    extend self

    def list_by(filter:, task_list:)
      task_list_id = task_list.id

      return Failure(:task_list_not_found) unless task_list.id

      relation = Item::Record.where(task_list_id:)

      relation =
        case filter
        when "completed" then relation.completed.order(completed_at: :desc)
        when "incomplete" then relation.incomplete.order(created_at: :desc)
        else relation.order(Arel.sql("task_items.completed_at DESC NULLS FIRST, task_items.created_at DESC"))
        end

      tasks = relation.map { entity!(_1) }

      Success(:tasks_found, tasks:)
    end

    def find_by(id:, task_list:)
      task_list_id = task_list.id

      return Failure(:task_list_not_found) unless task_list_id

      task = Item::Record.find_by(id:, task_list_id:)

      return Failure(:task_not_found) unless task

      block_given? ? yield(task) : success_with(:task_found, task)
    end

    def create!(name:, task_list:)
      task_list_id = task_list.id

      return Failure(:task_list_not_found) unless task_list_id

      task = Item::Record.create!(name:, task_list_id:)

      List::Record.increment_counter(:item_counter, task_list_id)

      success_with(:task_created, task)
    end

    def update!(id:, task_list:, **new_attributes)
      find_by(id:, task_list:) do |task|
        if task.update(new_attributes)
          success_with(:task_updated, task)
        else
          Failure(:invalid_task, task: entity(task))
        end
      end
    end

    def complete!(id:, task_list:)
      find_by(id:, task_list:) do |task|
        task.update!(completed_at: Time.current)

        success_with(:task_completed, task)
      end
    end

    def incomplete!(id:, task_list:)
      find_by(id:, task_list:) do |task|
        task.update!(completed_at: nil)

        success_with(:task_incomplete, task)
      end
    end

    def delete!(id:, task_list:)
      find_by(id:, task_list:) do |task|
        task.destroy!

        List::Record.decrement_counter(:item_counter, task_list.id)

        success_with(:task_deleted, task)
      end
    end

    private

    def entity(record)
      entity!(record)
        .tap { _1.errors.merge!(record.errors) if record.errors.any? }
    end

    def entity!(record)
      Item::Entity.new(
        id: record.id,
        name: record.name,
        completed_at: record.completed_at,
        created_at: record.created_at,
        updated_at: record.updated_at,
        task_list_id: record.task_list_id
      )
    end

    def success_with(type, record)
      Success(type, task: entity!(record))
    end
  end
end
