# frozen_string_literal: true

module Web::Tasks
  class ListsController < BaseController
    def index
      result = Account::Tasks::List::Listing.call(account: current_member)

      result.value => {relation: task_lists}

      render("web/tasks/lists", locals: {task_lists:})
    end

    def new
      input = Account::Tasks::List::Creation::Input.new

      render("web/tasks/lists/new", locals: {task_list: input})
    end

    def create
      case Account::Tasks::List::Creation.call(account: current_member, **task_list_params)
      in Solid::Success
        redirect_to web_tasks_lists_path, notice: "Task list created."
      in Solid::Failure(input:)
        render("web/tasks/lists/new", locals: {task_list: input}, status: :unprocessable_entity)
      end
    end

    def edit
      case Account::Tasks::List::Finding.call(account: current_member, id: params[:id])
      in Solid::Failure(:task_list_not_found | :invalid_input, _) then render_not_found_error
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_unprocessable_entity_error
      in Solid::Success(task_list:)
        input = Account::Tasks::List::Updating::Input.new(task_list.slice(:account, :id, :name))

        render("web/tasks/lists/edit", locals: {task_list: input})
      end
    end

    def update
      case Account::Tasks::List::Updating.call(account: current_member, id: params[:id], **task_list_params)
      in Solid::Failure(:task_list_not_found, _) then render_not_found_error
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_unprocessable_entity_error
      in Solid::Failure(input:)
        render("web/tasks/lists/edit", locals: {task_list: input}, status: :unprocessable_entity)
      in Solid::Success(task_list:)
        redirect_to web_tasks_lists_path, notice: "Task list updated."
      end
    end

    def destroy
      case Account::Tasks::List::Deletion.call(account: current_member, id: params[:id])
      in Solid::Failure(:task_list_not_found, _) then render_not_found_error
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_unprocessable_entity_error
      in Solid::Success
        self.current_task_list_id = nil

        redirect_to web_tasks_lists_path, notice: "Task list deleted."
      end
    end

    private

    def task_list_params
      params.require(:task_list).permit(:name)
    end
  end
end
