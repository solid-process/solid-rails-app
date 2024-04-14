# frozen_string_literal: true

module Web::Tasks
  class ItemsController < BaseController
    def index
      case Account::Tasks::Item::Listing.call(filter: "all", member: current_member)
      in Solid::Success(tasks:)
        render("web/tasks/filter/all", locals: {tasks:})
      end
    end

    def new
      render("web/tasks/items/new", locals: {task: Account::Tasks::Item::Creation::Input.new})
    end

    def create
      create_params = params.require(:task).permit(:name)

      create_input = {member: current_member, **create_params}

      case Account::Tasks::Item::Creation.call(create_input)
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Failure(input:)
        render("web/tasks/items/new", locals: {task: input})
      in Solid::Success
        redirect_to next_path, notice: "Task created."
      end
    end

    def edit
      case Account::Tasks::Item::Finding.call(member: current_member, id: params[:id])
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Success(task:)
        input = Account::Tasks::Item::Updating::Input.new(
          id: task.id,
          name: task.name,
          completed: task.completed?
        )

        render("web/tasks/items/edit", locals: {task: input})
      end
    end

    def update
      update_params = params.require(:task).permit(:name, :completed)

      update_input = {member: current_member, id: params[:id], **update_params}

      case Account::Tasks::Item::Updating.call(update_input)
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Failure(input:)
        render("web/tasks/items/edit", locals: {task: input})
      in Solid::Success
        redirect_to next_path, notice: "Task updated."
      end
    end

    def destroy
      case Account::Tasks::Item::Deletion.call(member: current_member, id: params[:id])
      in Solid::Failure(:task_not_found, _)
        render_not_found_error
      in Solid::Success
        redirect_to next_path, notice: "Task deleted."
      end
    end

    private

    helper_method def next_path
      case params[:back_to]
      when "completed" then completed_web_tasks_path
      when "incomplete" then incomplete_web_tasks_path
      else web_tasks_path
      end
    end
  end
end
