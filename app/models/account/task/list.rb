# frozen_string_literal: true

module Account::Task::List
  extend Solid::Context

  self.actions = {
    list: Listing,
    create!: Creation,
    delete!: Deletion,
    update!: Updating
  }

  def find_by(...) = Repository.find_by(...)

  def entity(member) = Entity.new(id: member.task_list_id)
end
