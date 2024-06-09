# frozen_string_literal: true

module Web::Task
  class Lists::SelectController < BaseController
    def update
      account = Account.entity(current_member)

      case Account.task_list.find_by(id: params[:id], account:)
      in Solid::Failure(:task_list_not_found, _)
        render_not_found_error
      in Solid::Success(task_list:)
        self.current_task_list_id = task_list.id

        redirect_to web_task_lists_path, notice: "Task list selected."
      end
    end
  end
end
