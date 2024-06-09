# frozen_string_literal: true

module Account
  extend Solid::Context

  import(
    member: Member,
    task_item: Task::Item,
    task_list: Task::List
  )

  def entity(member) = Entity.new(id: member.account_id)
end
