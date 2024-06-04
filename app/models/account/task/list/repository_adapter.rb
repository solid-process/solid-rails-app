# frozen_string_literal: true

module Account::Task::List
  module RepositoryAdapter
    extend Solid::Output.mixin
    extend self

    def list_by(account:)
      Record.where(account_id: account.id).order(created_at: :desc).map { entity(_1) }
    end

    def find_by(id:, account:)
      task_list = Record.find_by(id:, account_id: account.id)

      return Failure(:task_list_not_found) unless task_list

      return Failure(:inbox_cannot_be_edited) if task_list.inbox?

      block_given? ? yield(task_list) : success_with(:task_list_found, task_list)
    end

    def create!(name:, inbox:, account:)
      task_list = Record.create!(name:, inbox:, account_id: account.id)

      success_with(:task_list_created, task_list)
    rescue ::ActiveRecord::RecordNotUnique
      Failure(:task_list_already_exists)
    end

    def update!(id:, name:, account:)
      find_by(id:, account:) do |task_list|
        task_list.update!(name:)

        success_with(:task_list_updated, task_list)
      end
    end

    def destroy!(id:, account:)
      find_by(id:, account:) do |task_list|
        task_list.destroy!

        success_with(:task_list_deleted, task_list)
      end
    end

    private

    def entity(record)
      Entity.new(
        id: record.id,
        name: record.name,
        inbox: record.inbox,
        created_at: record.created_at,
        updated_at: record.updated_at
      )
    end

    def success_with(type, record)
      Success(type, task_list: entity(record))
    end
  end
end
