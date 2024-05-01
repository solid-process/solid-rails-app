# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ListsUpdateTest < ActionDispatch::IntegrationTest
  test "#update responds with 401 when access token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    put(api_v1_task_list_url(task_lists(:one_inbox)), headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#update responds with 404 when task list is not found" do
    user = users(:one)
    params = {task_list: {name: "Foo"}}
    headers = api_v1_authorization_header(user)

    put(api_v1_task_list_url(TaskList.maximum(:id) + 1), params:, headers:)

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 400 when params are missing" do
    user = users(:one)

    task_list = user.account.task_lists.create!(name: "Bar")

    params = [{}, {task_list: {}}, {task_list: nil}].sample

    put(api_v1_task_list_url(task_list), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:bad_request)
  end

  test "#update responds with 403 when trying to update the inbox task list" do
    user = users(:one)

    params = {task_list: {name: "Biz"}}

    put(api_v1_task_list_url(task_lists(:one_inbox)), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:forbidden)
  end

  test "#update responds with 422 when params are invalid" do
    user = users(:one)

    task_list = user.account.task_lists.create!(name: "Bar")

    params = {task_list: {name: [nil, ""].sample}}

    put(api_v1_task_list_url(task_list), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:unprocessable_entity)
  end

  test "#update responds with 200" do
    user = users(:one)

    task_list = user.account.task_lists.create!(name: "Bar")

    params = {task_list: {name: "Foo"}}

    put(api_v1_task_list_url(task_list), params:, headers: api_v1_authorization_header(user))

    json_data = assert_api_v1_response_with_success(:ok)

    assert_equal "Foo", json_data["name"]

    assert_equal json_data["name"], task_list.reload.name
  end
end
