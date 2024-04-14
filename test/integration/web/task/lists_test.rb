# frozen_string_literal: true

require "test_helper"

class WebTaskListsTest < ActionDispatch::IntegrationTest
  test "guest tries to access all task lists" do
    get(web_tasks_lists_url)

    assert_web_unauthorized_access
  end

  test "user views all task lists" do
    user = users(:one)

    create_task_list(user.account, name: "Foo")

    web_sign_in(user)

    get(web_tasks_lists_url)

    assert_response :ok

    assert_select("td", "Inbox 📌")
    assert_select("td", "Foo")
  end

  test "user destroys a task list" do
    user = users(:one)

    create_task_list(user.account, name: "Foo")

    web_sign_in(user)

    get(web_tasks_lists_url)

    assert_response :ok

    links = css_select("[data-confirm=\"Are you sure you want to delete this task list?\"]")

    assert_equal 1, links.size

    delete(links.first["href"])

    assert_redirected_to web_tasks_lists_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task list deleted.")
  end

  test "user tries to destroy the inbox task list" do
    user = users(:one)

    web_sign_in(user)

    delete(web_tasks_list_url(user.inbox))

    assert_response :unprocessable_entity
  end

  test "user tries to destroy a task list from another user" do
    user = users(:one)
    task_list = task_lists(:two_inbox)

    web_sign_in(user)

    delete(web_tasks_list_url(task_list))

    assert_response :not_found
  end
end
