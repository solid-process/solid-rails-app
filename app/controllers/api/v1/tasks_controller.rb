# frozen_string_literal: true

module API::V1
  class TasksController < BaseController
    include Tasks::Concerns::Finding
    include Tasks::Concerns::Rendering

    before_action :set_task, only: [:update, :destroy]

    def index
      relation = @task_list.tasks

      relation =
        case params[:filter]
        when "completed" then relation.completed.order(completed_at: :desc)
        when "incomplete" then relation.incomplete.order(created_at: :desc)
        else relation.order(Arel.sql("tasks.completed_at DESC NULLS FIRST, tasks.created_at DESC"))
        end

      data = relation.pluck(task_attribute_names).collect! { map_json_attributes(_1) }

      render_json_with_success(status: :ok, data:)
    end

    def create
      task = @task_list.tasks.new(task_params)

      if task.save
        render_json_with_attributes(task, :created)
      else
        render_json_with_model_errors(task)
      end
    end

    def update
      if @task.update(task_params)
        render_json_with_attributes(@task, :ok)
      else
        render_json_with_model_errors(@task)
      end
    end

    def destroy
      @task.destroy!

      render_json_with_success(status: :ok)
    end

    private

    def task_params
      @task_params ||=
        case action_name
        when "create" then params.require(:task).permit(:name)
        when "update" then params.require(:task).permit(:name, :completed)
        end
    end
  end
end
