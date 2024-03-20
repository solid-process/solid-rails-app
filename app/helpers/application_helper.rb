module ApplicationHelper
  def current_task_list_name
    "List: #{current_task_list&.name}"
  end
end
