# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ItemsDestroyTest < ActionDispatch::IntegrationTest
  test "#destroy responds with 401 when access token is invalid" do
    user = users(:one)
    task = task_items(:one)
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    delete(api_v1_task_list_item_url(user.inbox, task), headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#destroy responds with 404 when task list is not found" do
    user = users(:one)
    task = task_items(:one)

    url = api_v1_task_list_item_url(list_id: TaskList.maximum(:id) + 1, id: task.id)

    delete(url, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#destroy responds with 404 when task is not found" do
    user = users(:one)

    url = api_v1_task_list_item_url(list_id: user.inbox, id: TaskItem.maximum(:id) + 1)

    delete(url, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#destroy responds with 404 when task list belongs to another user" do
    user = users(:one)
    task = task_items(:two)

    delete(api_v1_task_list_item_url(task.task_list, task), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#destroy responds with 200 when task is destroyed" do
    user = users(:one)
    task = task_items(:one)

    assert_difference -> { user.task_items.count }, -1 do
      delete(api_v1_task_list_item_url(user.inbox, task), headers: api_v1_authorization_header(user))
    end

    assert_api_v1_response_with_success(:ok)
  end
end
