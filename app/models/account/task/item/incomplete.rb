# frozen_string_literal: true

class Account::Task::Item::Incomplete < Solid::Process
  self.input = Account::Task::Item::Finding::Input

  def call(attributes)
    case Account::Task::Item::Finding.call(attributes)
    in Solid::Failure(type, value) then Failure(type, **value)
    in Solid::Success(task:)
      task.update!(completed_at: nil)

      Success(:task_incomplete, task:)
    end
  end
end
