# frozen_string_literal: true

module Account::Task
  class Item::Listing < Solid::Process
    input do
      attribute :member
      attribute :filter, default: "all"

      validates :member, instance_of: Account::Member
    end

    def call(attributes)
      attributes => { member:, filter: }

      return Failure(:task_list_not_found) unless member.authorized?

      tasks = Item::Record.where(task_list_id: member.task_list_id)

      tasks =
        case filter
        when "completed" then tasks.completed.order(completed_at: :desc)
        when "incomplete" then tasks.incomplete.order(created_at: :desc)
        else tasks.order(Arel.sql("task_items.completed_at DESC NULLS FIRST, task_items.created_at DESC"))
        end

      Success(:tasks_found, tasks:)
    end
  end
end
