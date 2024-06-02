# frozen_string_literal: true

require "test_helper"

class WebTaskListsEditingTest < ActionDispatch::IntegrationTest
  test "guest tries to access edit task list form" do
    user = users(:one)

    task_list = create_task_list(member_record(user).account, name: "Foo")

    get(edit_web_task_list_url(task_list))

    assert_web_unauthorized_access
  end

  test "guest tries to update a task list" do
    user = users(:one)

    task_list = create_task_list(member_record(user).account, name: "Foo")

    put(web_task_list_url(task_list), params: {task_list: {name: "Bar"}})

    assert_web_unauthorized_access
  end

  test "user tries to edit the inbox task list" do
    user = users(:one)

    web_sign_in(user)

    get(edit_web_task_list_url(task_lists(:one_inbox)))

    assert_response :unprocessable_entity
  end

  test "user tries to update the inbox task list" do
    user = users(:one)

    web_sign_in(user)

    put(web_task_list_url(task_lists(:one_inbox)), params: {task_list: {name: "Bar"}})

    assert_response :unprocessable_entity
  end

  test "user updates a task list with invalid data" do
    user = users(:one)
    task_list = create_task_list(member_record(user).account, name: "Foo")

    web_sign_in(user)

    get(edit_web_task_list_url(task_list))

    assert_response :ok

    assert_select("h2", "Edit task list ##{task_list.id}")

    assert_select("textarea", task_list.name)

    put(web_task_list_url(task_list), params: {task_list: {name: ""}})

    assert_response :unprocessable_entity

    assert_select("li", "Name can't be blank")
  end

  test "user updates a task list with valid data" do
    user = users(:one)
    task_list = create_task_list(member_record(user).account, name: "Foo")

    web_sign_in(user)

    get(edit_web_task_list_url(task_list))

    assert_response :ok

    assert_select("h2", "Edit task list ##{task_list.id}")

    assert_select("textarea", task_list.name)

    put(web_task_list_url(task_list), params: {task_list: {name: "Bar"}})

    assert_redirected_to web_task_lists_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task list updated.")

    assert_select("td", "Bar")
  end

  test "user tries to update a task list from another user" do
    user1 = users(:one)
    user2 = users(:two)

    account = member_record(user2).account

    task_list2 = create_task_list(account, name: "Foo")

    web_sign_in(user1)

    put(web_task_list_url(task_list2), params: {task_list: {name: "Bar"}})

    assert_response :not_found
  end
end
