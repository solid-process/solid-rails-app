# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ItemsCompleteTest < ActionDispatch::IntegrationTest
  test "#update responds with 401 when API token is invalid" do
    user = users(:one)
    task = task_items(:one)
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    put(complete_api_v1_task_list_item_url(user.inbox, task), headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#update responds with 404 when task list is not found" do
    user = users(:one)
    task = task_items(:one)

    list_id = Account::Task::List::Record.maximum(:id) + 1

    url = complete_api_v1_task_list_item_url(list_id:, id: task.id)

    put(url, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 404 when task is not found" do
    user = users(:one)

    id = Account::Task::Item::Record.maximum(:id) + 1

    url = complete_api_v1_task_list_item_url(list_id: user.inbox, id:)

    put(url, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 404 when task list belongs to another user" do
    user = users(:one)
    task = task_items(:two)

    put(complete_api_v1_task_list_item_url(task.task_list, task), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#update responds with 200 when task is marked as completed" do
    user = users(:one)

    task = task_items(:one).then { incomplete_task(_1) }

    assert_changes -> { task.reload.completed_at } do
      put(complete_api_v1_task_list_item_url(user.inbox, task), headers: api_v1_authorization_header(user))
    end

    assert_kind_of(Time, task.completed_at)

    json_data = assert_api_v1_response_with_success(:ok)

    assert_equal(task.id, json_data[:id])
    assert_not_nil(json_data[:completed_at])
  end
end
