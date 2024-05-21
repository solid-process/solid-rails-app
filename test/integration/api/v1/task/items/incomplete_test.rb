# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ItemsIncompleteTest < ActionDispatch::IntegrationTest
  test "#update responds with 401 when API token is invalid" do
    user = users(:one)
    task = task_items(:one)
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    put(incomplete_api_v1_task_list_item_url(user.inbox, task), headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#update responds with 404 when task list is not found" do
    user = users(:one)
    task = task_items(:one)

    url = incomplete_api_v1_task_list_item_url(list_id: TaskList.maximum(:id) + 1, id: task.id)

    put(url, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 404 when task is not found" do
    user = users(:one)

    url = incomplete_api_v1_task_list_item_url(list_id: user.inbox, id: TaskItem.maximum(:id) + 1)

    put(url, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 404 when task list belongs to another user" do
    user = users(:one)
    task = task_items(:two)

    put(incomplete_api_v1_task_list_item_url(task.task_list, task), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 200 when task is marked as completed" do
    user = users(:one)
    task = task_items(:one).then { complete_task(_1) }

    assert_changes -> { task.reload.completed_at } do
      put(incomplete_api_v1_task_list_item_url(user.inbox, task), headers: api_v1_authorization_header(user))
    end

    assert_nil(task.completed_at)

    json_data = assert_api_v1_response_with_success(:ok)

    assert_equal(task.id, json_data[:id])
    assert_nil(json_data[:completed_at])
  end
end
