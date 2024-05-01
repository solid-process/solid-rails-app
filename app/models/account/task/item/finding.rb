# frozen_string_literal: true

class Account::Task::Item::Finding < Solid::Process
  input do
    attribute :id, :integer
    attribute :member

    validates :id, numericality: {only_integer: true, greater_than: 0}
    validates :member, instance_of: Account::Member
  end

  def call(attributes)
    attributes => { member:, id: }

    return Failure(:task_list_not_found) unless member.authorized?

    task = TaskItem.find_by(id:, task_list_id: member.task_list_id)

    return Failure(:task_not_found) unless task

    Success(:task_found, task:)
  end
end
