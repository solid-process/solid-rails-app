module ApplicationHelper
  def current_task_list_name
    current_task_list&.name
  end
end
