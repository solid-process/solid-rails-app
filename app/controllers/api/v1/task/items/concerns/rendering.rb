# frozen_string_literal: true

module API::V1
  module Task::Items::Concerns::Rendering
    TASK_ATTRIBUTES = [:id, :name, :completed_at, :created_at, :updated_at, :task_list_id].freeze

    private

    def task_attribute_names
      TASK_ATTRIBUTES
    end

    def render_json_with_attributes(task, status)
      attributes = task.values_at(*task_attribute_names)

      data = map_json_attributes(attributes)

      render_json_with_success(status:, data:)
    end

    def map_json_attributes((id, name, completed_at, created_at, updated_at, task_list_id))
      {id:, name:, completed_at:, created_at:, updated_at:, task_list_id:}
    end
  end
end
