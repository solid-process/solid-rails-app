# frozen_string_literal: true

module Account::Task::Item
  module Repository
    extend Solid::Output.mixin
    extend self

    def list_by(filter:, member:)
      task_list_id = member.task_list_id

      return Failure(:task_list_not_found) unless task_list_id

      tasks = Record.where(task_list_id:)

      tasks =
        case filter
        when "completed" then tasks.completed.order(completed_at: :desc)
        when "incomplete" then tasks.incomplete.order(created_at: :desc)
        else tasks.order(Arel.sql("task_items.completed_at DESC NULLS FIRST, task_items.created_at DESC"))
        end

      Success(:tasks_found, tasks:)
    end

    def find_by(id:, member:)
      task_list_id = member.task_list_id

      return Failure(:task_list_not_found) unless task_list_id

      task = Record.find_by(id:, task_list_id:)

      return Failure(:task_not_found) unless task

      block_given? ? yield(task) : Success(:task_found, task:)
    end

    def create!(name:, member:)
      task_list_id = member.task_list_id

      return Failure(:task_list_not_found) unless task_list_id

      task = Record.create!(name:, task_list_id:)

      Success(:task_created, task:)
    end

    def update!(id:, member:, **new_attributes)
      find_by(id:, member:) do |task|
        if task.update(new_attributes)
          Success(:task_updated, task:)
        else
          Failure(:invalid_task, task:)
        end
      end
    end

    def complete!(id:, member:)
      find_by(id:, member:) do |task|
        task.update!(completed_at: Time.current)

        Success(:task_completed, task:)
      end
    end

    def incomplete!(id:, member:)
      find_by(id:, member:) do |task|
        task.update!(completed_at: nil)

        Success(:task_incomplete, task:)
      end
    end

    def delete!(id:, member:)
      find_by(id:, member:) do |task|
        task.destroy!

        Success(:task_deleted, task:)
      end
    end
  end
end
