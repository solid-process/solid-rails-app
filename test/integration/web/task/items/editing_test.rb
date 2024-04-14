# frozen_string_literal: true

require "test_helper"

class WebTaskItemsEditingTest < ActionDispatch::IntegrationTest
  test "guest tries to access new task form" do
    get(edit_web_task_url(tasks(:one)))

    assert_web_unauthorized_access
  end

  test "guest tries to create a task" do
    put(web_task_url(tasks(:one)), params: {task: {name: "Foo"}})

    assert_web_unauthorized_access
  end

  test "user tries to update a task from another user" do
    user = users(:one)
    task = tasks(:two)

    web_sign_in(user)

    put(web_task_url(task), params: {task: {name: "Foo"}})

    assert_response :not_found
  end

  test "user updates a task with valid data" do
    user = users(:one)
    task = tasks(:one)

    web_sign_in(user)

    get(edit_web_task_url(task))

    assert_response :ok

    assert_select("h2", "Edit task ##{task.id}")

    assert_select("textarea", task.name)

    assert_select("input[type=\"checkbox\"]:not(checked)")

    put(web_task_url(tasks(:one)), params: {task: {name: "Bar", completed: true}})

    assert_redirected_to web_tasks_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task updated.")

    assert_select("td", "Bar")

    get(edit_web_task_url(task))

    assert_select("input[type=\"checkbox\"][checked]")
  end

  test "user updates a task with invalid data" do
    user = users(:one)
    task = tasks(:one)

    web_sign_in(user)

    put(web_task_url(task), params: {task: {name: ""}})

    assert_response :ok

    assert_select("li", "Name can't be blank")
  end
end
