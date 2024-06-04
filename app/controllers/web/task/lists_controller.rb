# frozen_string_literal: true

module Web::Task
  class ListsController < BaseController
    def index
      account = Account::Entity.new(id: current_member.account_id)

      result = Account::Task::List::Listing.call(account:)

      result.value => {relation: task_lists}

      render("web/task/lists/index", locals: {task_lists:})
    end

    def new
      input = Account::Task::List::Creation::Input.new

      render("web/task/lists/new", locals: {task_list: input})
    end

    def create
      account = Account::Entity.new(id: current_member.account_id)

      case Account::Task::List::Creation.call(account:, **task_list_params)
      in Solid::Success
        redirect_to web_task_lists_path, notice: "Task list created."
      in Solid::Failure(input:)
        render("web/task/lists/new", locals: {task_list: input}, status: :unprocessable_entity)
      end
    end

    def edit
      account = Account::Entity.new(id: current_member.account_id)

      case Account::Task::List::Repository.find_by(account:, id: params[:id])
      in Solid::Failure(:task_list_not_found | :invalid_input, _) then render_not_found_error
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_unprocessable_entity_error
      in Solid::Success(task_list:)
        input = Account::Task::List::Updating::Input.new(task_list.slice(:id, :name))

        render("web/task/lists/edit", locals: {task_list: input})
      end
    end

    def update
      account = Account::Entity.new(id: current_member.account_id)

      case Account::Task::List::Updating.call(account:, id: params[:id], **task_list_params)
      in Solid::Failure(:task_list_not_found, _) then render_not_found_error
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_unprocessable_entity_error
      in Solid::Failure(input:)
        render("web/task/lists/edit", locals: {task_list: input}, status: :unprocessable_entity)
      in Solid::Success(task_list:)
        redirect_to web_task_lists_path, notice: "Task list updated."
      end
    end

    def destroy
      account = Account::Entity.new(id: current_member.account_id)

      case Account::Task::List::Deletion.call(account:, id: params[:id])
      in Solid::Failure(:task_list_not_found, _) then render_not_found_error
      in Solid::Failure(:inbox_cannot_be_edited, _) then render_unprocessable_entity_error
      in Solid::Success
        self.current_task_list_id = nil

        redirect_to web_task_lists_path, notice: "Task list deleted."
      end
    end

    private

    def task_list_params
      params.require(:task_list).permit(:name)
    end
  end
end
