# frozen_string_literal: true

require "test_helper"

class WebTaskListsSelectionTest < ActionDispatch::IntegrationTest
  test "guest tries to select a task list" do
    user = users(:one)

    task_list = create_task_list(user.account, name: "Foo")

    put(select_web_tasks_list_url(task_list))

    assert_web_unauthorized_access
  end

  test "user selects a task list" do
    user = users(:one)

    task_list = create_task_list(user.account, name: "Foo")

    web_sign_in(user)

    assert_changes -> { session[:task_list_id] } do
      put(select_web_tasks_list_url(task_list))
    end

    assert_redirected_to web_tasks_lists_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task list selected")

    assert_equal task_list.id, session[:task_list_id]

    assert_select("td", "Foo selected")
    assert_select("td", "Inbox")
  end

  test "user tries to select a task list from another user" do
    user = users(:one)
    task_list = task_lists(:two_inbox)

    web_sign_in(user)

    put(select_web_tasks_list_url(task_list))

    assert_response :not_found
  end
end
