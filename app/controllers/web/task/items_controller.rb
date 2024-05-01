# frozen_string_literal: true

module Web::Task
  class ItemsController < BaseController
    def index
      case Account::Task::Item::Listing.call(filter: "all", member: current_member)
      in Solid::Success(tasks:)
        render("web/task/items/index", locals: {tasks:, scope: "all"})
      end
    end

    def new
      render("web/task/items/new", locals: {task: Account::Task::Item::Creation::Input.new})
    end

    def create
      create_params = params.require(:task).permit(:name)

      create_input = {member: current_member, **create_params}

      case Account::Task::Item::Creation.call(create_input)
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Failure(input:)
        render("web/task/items/new", locals: {task: input})
      in Solid::Success
        redirect_to next_path, notice: "Task created."
      end
    end

    def edit
      case Account::Task::Item::Finding.call(member: current_member, id: params[:id])
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Success(task:)
        input = Account::Task::Item::Updating::Input.new(
          id: task.id,
          name: task.name,
          completed: task.completed?
        )

        render("web/task/items/edit", locals: {task: input})
      end
    end

    def update
      update_params = params.require(:task).permit(:name, :completed)

      update_input = {member: current_member, id: params[:id], **update_params}

      case Account::Task::Item::Updating.call(update_input)
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Failure(input:)
        render("web/task/items/edit", locals: {task: input})
      in Solid::Success
        redirect_to next_path, notice: "Task updated."
      end
    end

    def destroy
      case Account::Task::Item::Deletion.call(member: current_member, id: params[:id])
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
