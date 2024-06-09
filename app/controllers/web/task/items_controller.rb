# frozen_string_literal: true

module Web::Task
  class ItemsController < BaseController
    def index
      task_list = Account.task_list.entity(current_member)

      case Account.task_item.list(task_list:, filter: "all")
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "all"})
      end
    end

    def new
      render("web/task/items/new", locals: {task: Account.task_item.create!.input.new})
    end

    def create
      create_params = params.require(:task).permit(:name)

      task_list = Account.task_list.entity(current_member)

      case Account.task_item.create!(task_list:, **create_params)
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Failure(input:)
        render("web/task/items/new", locals: {task: input})
      in Solid::Success
        redirect_to next_path, notice: "Task created."
      end
    end

    def edit
      task_list = Account.task_list.entity(current_member)

      case Account.task_item.find_by(task_list:, id: params[:id])
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Success(task:)
        input = Account.task_item.update!.input.new(
          id: task.id,
          name: task.name,
          completed: task.completed?
        )

        render("web/task/items/edit", locals: {task: input})
      end
    end

    def update
      update_params = params.require(:task).permit(:name, :completed)

      task_list = Account.task_list.entity(current_member)

      case Account.task_item.update!(task_list:, id: params[:id], **update_params)
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Failure(input:)
        render("web/task/items/edit", locals: {task: input})
      in Solid::Success
        redirect_to next_path, notice: "Task updated."
      end
    end

    def destroy
      task_list = Account.task_list.entity(current_member)

      case Account.task_item.delete!(task_list:, id: params[:id])
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Success
        redirect_to next_path, notice: "Task deleted."
      end
    end

    private

    helper_method def next_path
      case params[:back_to]
      when "completed" then completed_web_task_items_path
      when "incomplete" then incomplete_web_task_items_path
      else web_task_items_path
      end
    end
  end
end
