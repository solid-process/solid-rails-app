# frozen_string_literal: true

require "test_helper"

class WebTaskListsCreationTest < ActionDispatch::IntegrationTest
  test "guest tries to access new task list form" do
    get(new_web_task_list_url)

    assert_web_unauthorized_access
  end

  test "guest tries to create a task list" do
    post(web_task_lists_url, params: {task_list: {name: "Foo"}})

    assert_web_unauthorized_access
  end

  test "user creates a task list with invalid data" do
    user = users(:one)

    web_sign_in(user)

    get(new_web_task_list_url)

    assert_response :ok

    assert_select("h2", "New list")

    assert_no_difference(-> { member_record(user).account.task_lists.count }) do
      post(web_task_lists_url, params: {task_list: {name: ""}})
    end

    assert_response :unprocessable_entity

    assert_select("li", "Name can't be blank")
  end

  test "user creates a task list with valid data" do
    user = users(:one)

    web_sign_in(user)

    assert_difference(-> { member_record(user).account.task_lists.count }) do
      post(web_task_lists_url, params: {task_list: {name: "Foo"}})
    end

    assert_redirected_to web_task_lists_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task list created.")

    assert_select("td", "Foo")
  end
end
