# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ItemsCreateTest < ActionDispatch::IntegrationTest
  test "#create responds with 401 when API token is invalid" do
    user = users(:one)
    params = {task: {name: "Foo"}}
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    post(api_v1_task_list_items_url(user.inbox), params:, headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#create responds with 400 when params are missing" do
    user = users(:one)
    params = [{}, {task: {}}, {task: nil}].sample

    post(api_v1_task_list_items_url(user.inbox), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:bad_request)
  end

  test "#create responds with 404 when task list is not found" do
    user = users(:one)
    params = {task: {name: "Foo"}}

    list_id = Account::Task::List::Record.maximum(:id) + 1

    post(api_v1_task_list_items_url(list_id), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#index responds with 404 when task list belongs to another user" do
    user = users(:one)
    task_list = task_lists(:two_inbox)
    params = {task: {name: "Foo"}}

    post(api_v1_task_list_items_url(task_list), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#create responds with 422 when name is invalid" do
    user = users(:one)
    params = {task: {name: [nil, ""].sample}}

    post(api_v1_task_list_items_url(user.inbox), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:unprocessable_entity)
  end

  test "#create responds with 201 when task is created" do
    user = users(:one)
    params = {task: {name: "Foo"}}

    assert_difference -> { user.inbox.task_items.count } do
      post(api_v1_task_list_items_url(user.inbox), params:, headers: api_v1_authorization_header(user))
    end

    json_data = assert_api_v1_response_with_success(:created)

    assert_equal "Foo", json_data["name"]

    assert user.task_items.exists?(json_data["id"])
  end
end
