# frozen_string_literal: true

module Account::Task::List
  module Repository
    extend Solid::Output.mixin
    extend self

    def list_by(account:)
      Record.where(account_id: account_id(account)).order(created_at: :desc)
    end

    def find_by(id:, account:)
      task_list = Record.find_by(id:, account_id: account_id(account))

      return Failure(:task_list_not_found) unless task_list

      return Failure(:inbox_cannot_be_edited) if task_list.inbox?

      block_given? ? yield(task_list) : Success(:task_list_found, task_list:)
    end

    def create!(name:, inbox:, account:)
      task_list = Record.create!(name:, inbox:, account_id: account_id(account))

      Success(:task_list_created, task_list:)
    rescue ::ActiveRecord::RecordNotUnique
      Failure(:task_list_already_exists)
    end

    def update!(id:, name:, account:)
      find_by(id:, account:) do |task_list|
        task_list.update!(name:)

        Success(:task_list_updated, task_list:)
      end
    end

    def destroy!(id:, account:)
      find_by(id:, account:) do |task_list|
        task_list.destroy!

        Success(:task_list_deleted, task_list:)
      end
    end

    private

    def account_id(account)
      case account
      in Account::Record then account.id
      in Account::Member then account.account_id
      end
    end
  end
end
