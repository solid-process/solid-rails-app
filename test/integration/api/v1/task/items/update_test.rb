# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ItemsUpdateTest < ActionDispatch::IntegrationTest
  test "#update responds with 401 when access token is invalid" do
    user = users(:one)
    task = task_items(:one)
    params = {task: {name: "Foo"}}
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    put(api_v1_task_list_item_url(user.inbox, task), params:, headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#update responds with 400 when params are missing" do
    user = users(:one)
    task = task_items(:one)
    params = [{}, {task: {}}, {task: nil}].sample

    put(api_v1_task_list_item_url(user.inbox, task), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:bad_request)
  end

  test "#update responds with 404 when task list is not found" do
    user = users(:one)
    task = task_items(:one)
    params = {task: {name: "Foo"}}

    url = api_v1_task_list_item_url(list_id: TaskList.maximum(:id) + 1, id: task.id)

    put(url, params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 404 when task is not found" do
    user = users(:one)
    params = {task: {name: "Foo"}}

    url = api_v1_task_list_item_url(list_id: user.inbox, id: TaskItem.maximum(:id) + 1)

    put(url, params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 404 when task list belongs to another user" do
    user = users(:one)
    task = task_items(:two)
    params = {task: {name: "Foo"}}

    put(api_v1_task_list_item_url(task.task_list, task), params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 200 when task is updated" do
    user = users(:one)
    task = task_items(:one)
    params = {task: {name: SecureRandom.hex}}

    put(api_v1_task_list_item_url(user.inbox, task), params:, headers: api_v1_authorization_header(user))

    json_data = assert_api_v1_response_with_success(:ok)

    updated_task = user.task_items.find(json_data["id"])

    assert_equal params[:task][:name], updated_task.name
  end

  test "#update responds with 200 when marking task as completed" do
    user = users(:one)
    task = task_items(:one)
    params = {task: {completed: [true, 1, "1", "true"].sample}}

    put(api_v1_task_list_item_url(user.inbox, task), params:, headers: api_v1_authorization_header(user))

    json_data = assert_api_v1_response_with_success(:ok)

    updated_task = user.task_items.find(json_data["id"])

    assert updated_task.completed_at.present?
  end

  test "#update responds with 200 when marking task as incomplete" do
    user = users(:one)
    task = task_items(:one).then { complete_task(_1) }

    params = {task: {completed: [false, 0, "0", "false"].sample}}

    put(api_v1_task_list_item_url(user.inbox, task), params:, headers: api_v1_authorization_header(user))

    json_data = assert_api_v1_response_with_success(:ok)

    updated_task = user.task_items.find(json_data["id"])

    assert updated_task.completed_at.blank?
  end
end
