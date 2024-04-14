# frozen_string_literal: true

class Account::Tasks::Item::Deletion < Solid::Process
  self.input = Account::Tasks::Item::Finding::Input

  def call(attributes)
    case Account::Tasks::Item::Finding.call(attributes)
    in Solid::Failure(type, value) then Failure(type, **value)
    in Solid::Success(task:)
      task.destroy!

      Success(:task_deleted, task:)
    end
  end
end
