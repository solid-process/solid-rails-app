# frozen_string_literal: true

class Account::Tasks::Item::Completion < Solid::Process
  self.input = Account::Tasks::Item::Finding::Input

  def call(attributes)
    case Account::Tasks::Item::Finding.call(attributes)
    in Solid::Failure(type, value) then Failure(type, **value)
    in Solid::Success(task:)
      task.update!(completed_at: Time.current)

      Success(:task_completed, task:)
    end
  end
end
