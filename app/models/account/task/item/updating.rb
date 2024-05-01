# frozen_string_literal: true

class Account::Task::Item::Updating < Solid::Process
  UNDEFINED = Object.new

  input do
    attribute :id, :integer
    attribute :name, :string, default: UNDEFINED
    attribute :completed, :boolean, default: UNDEFINED
    attribute :member

    before_validation do
      self.name = name&.strip
    end

    validates :id, numericality: {only_integer: true, greater_than: 0}
    validates :name, presence: true
    validates :member, instance_of: Account::Member
  end

  def call(attributes)
    Given(attributes)
      .and_then(:find_task)
      .and_then(:update_task)
  end

  private

  def find_task(id:, member:, **)
    case Account::Task::Item::Finding.call(id:, member:)
    in Solid::Success(task:) then Continue(task:)
    in Solid::Failure(type, value) then Failure(type, **value)
    end
  end

  def update_task(task:, name:, completed:, **)
    new_attributes = {}
    new_attributes[:name] = name if name != UNDEFINED
    new_attributes[:completed_at] = completed_at if completed != UNDEFINED

    if task.update(new_attributes)
      Success(:task_updated, task:)
    else
      input.name = task.name
      input.completed = task.completed?

      input.errors.merge!(task.errors)

      Failure(:invalid_input, input:)
    end
  end

  def completed_at = input.completed ? Time.current : nil
end
