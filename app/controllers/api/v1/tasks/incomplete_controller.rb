# frozen_string_literal: true

module API::V1
  class Tasks::IncompleteController < BaseController
    include Tasks::Concerns::Finding
    include Tasks::Concerns::Rendering

    before_action :set_task, only: [:update]

    def update
      @task.incomplete!

      render_json_with_attributes(@task, :ok)
    end
  end
end
