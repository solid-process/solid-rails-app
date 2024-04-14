# frozen_string_literal: true

require "test_helper"

class API::V1::TasksCreateTest < ActionDispatch::IntegrationTest
  test "#create responds with 401 when access token is invalid" do
    user = users(:one)
    params = {task: {name: "Foo"}}
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    post(api_v1_task_list_tasks_url(user.inbox), params:, headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#create responds with 400 when params are missing" do
    user = users(:one)
    params = [{}, {task: {}}, {task: nil}].sample

    post(api_v1_task_list_tasks_url(user.inbox), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:bad_request)
  end

  test "#create responds with 404 when task list is not found" do
    user = users(:one)
    params = {task: {name: "Foo"}}

    post(api_v1_task_list_tasks_url(TaskList.maximum(:id) + 1), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#index responds with 404 when task list belongs to another user" do
    user = users(:one)
    task_list = task_lists(:two_inbox)
    params = {task: {name: "Foo"}}

    post(api_v1_task_list_tasks_url(task_list), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#create responds with 422 when name is invalid" do
    user = users(:one)
    params = {task: {name: [nil, ""].sample}}

    post(api_v1_task_list_tasks_url(user.inbox), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:unprocessable_entity)
  end

  test "#create responds with 201 when task is created" do
    user = users(:one)
    params = {task: {name: "Foo"}}

    assert_difference -> { user.inbox.tasks.count } do
      post(api_v1_task_list_tasks_url(user.inbox), params:, headers: api_v1_authorization_header(user))
    end

    json_data = assert_api_v1_response_with_success(:created)

    assert_equal "Foo", json_data["name"]

    assert user.tasks.exists?(json_data["id"])
  end
end
