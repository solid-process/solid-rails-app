# frozen_string_literal: true

require "test_helper"

class WebTaskItemsCreationTest < ActionDispatch::IntegrationTest
  test "guest tries to access new task form" do
    get(new_web_task_url)

    assert_web_unauthorized_access
  end

  test "guest tries to create a task" do
    post(web_tasks_url, params: {task: {name: "Foo"}})

    assert_web_unauthorized_access
  end

  test "user creates a task with valid data" do
    user = users(:one)

    web_sign_in(user)

    get(new_web_task_url)

    assert_response :ok

    assert_select("h2", "New task")

    assert_difference(-> { user.inbox.tasks.count }) do
      post(web_tasks_url, params: {task: {name: "Bar"}})
    end

    assert_redirected_to web_tasks_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task created.")

    assert_select("p", /All \(2\)/)

    assert_select("td", "Bar")
  end

  test "user creates a task with invalid data" do
    user = users(:one)

    web_sign_in(user)

    assert_no_difference(-> { user.inbox.tasks.count }) do
      post(web_tasks_url, params: {task: {name: ""}})
    end

    assert_response :ok

    assert_select("li", "Name can't be blank")
  end
end
