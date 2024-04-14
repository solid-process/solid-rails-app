# frozen_string_literal: true

class Account::Tasks::Item::Creation < Solid::Process
  input do
    attribute :name, :string
    attribute :member

    before_validation do
      self.name = name&.strip
    end

    validates :name, presence: true
    validates :member, instance_of: Account::Member
  end

  def call(attributes)
    attributes => {name:, member:}

    return Failure(:task_list_not_found) unless member.authorized?

    task = Task.create!(name:, task_list_id: member.task_list_id)

    Success(:task_created, task:)
  end
end
