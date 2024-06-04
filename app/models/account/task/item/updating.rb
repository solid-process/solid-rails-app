# frozen_string_literal: true

module Account::Task
  class Item::Updating < Solid::Process
    UNDEFINED = Object.new

    deps do
      attribute :repository, default: Item::Repository

      validates :repository, respond_to: [:update!]
    end

    input do
      attribute :id, :integer
      attribute :name, :string, default: UNDEFINED
      attribute :completed, :boolean, default: UNDEFINED
      attribute :task_list

      before_validation do
        self.name = name&.strip
      end

      validates :id, numericality: {only_integer: true, greater_than: 0}
      validates :name, presence: true
      validates :task_list, instance_of: List::Entity
    end

    def call(attributes)
      Given(attributes)
        .and_then(:map_attributes)
        .and_then(:update_task_item)
        .and_expose(:task_updated, %i[task])
    end

    private

    MAP_COMPLETED_AT = ->(completed) { Time.current if completed }

    def map_attributes(name:, completed:, **)
      new_attributes = {}
      new_attributes[:name] = name if name != UNDEFINED
      new_attributes[:completed_at] = MAP_COMPLETED_AT[completed] if completed != UNDEFINED

      Continue(new_attributes:)
    end

    def update_task_item(id:, task_list:, new_attributes:, **)
      case deps.repository.update!(id:, task_list:, **new_attributes)
      in Solid::Success(task:) then Continue(task:)
      in Solid::Failure(:task_not_found, _) then Failure(:task_not_found)
      in Solid::Failure(:task_list_not_found, _) then Failure(:task_list_not_found)
      in Solid::Failure(task:)
        input.name = task.name
        input.completed = task.completed?
        input.errors.merge!(task.errors)

        Failure(:invalid_input, input:)
      end
    end
  end
end
