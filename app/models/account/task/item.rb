# frozen_string_literal: true

module Account::Task::Item
  extend Solid::Context

  self.actions = {
    list: Listing,
    create!: Creation,
    delete!: Deletion,
    update!: Updating,
    complete: Completion,
    incomplete: Incomplete
  }

  def find_by(...) = Repository.find_by(...)
end
