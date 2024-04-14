# frozen_string_literal: true

class Account::Tasks::List::Deletion < Solid::Process
  self.input = Account::Tasks::List::Finding::Input

  def call(attributes)
    case Account::Tasks::List::Finding.call(attributes)
    in Solid::Failure(type, value) then Failure(type, **value)
    in Solid::Success(task_list:)
      task_list.destroy!

      Success(:task_list_deleted, task_list:)
    end
  end
end
