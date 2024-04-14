# frozen_string_literal: true

require "test_helper"

class API::V1::TasksIndexTest < ActionDispatch::IntegrationTest
  test "#index responds with 401 when access token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    get(api_v1_task_list_tasks_url(TaskList.inbox.first), headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#index responds with 404 when task list is not found" do
    user = users(:one)

    get(api_v1_task_list_tasks_url(user.task_lists.maximum(:id) + 1), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#index responds with 404 when task list belongs to another user" do
    user = users(:one)

    get(api_v1_task_list_tasks_url(users(:two).task_lists.first), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#index responds with 200" do
    user = users(:one)

    task1 = user.inbox.tasks.first
    task2 = create_task(user, name: "Foo")
    task2.update_column(:completed_at, Time.current)

    get(api_v1_task_list_tasks_url(user.inbox), headers: api_v1_authorization_header(user))

    collection = assert_api_v1_response_with_success(:ok)

    assert_equal 2, collection.size

    tasks_json_by_id = collection.index_by { _1[:id] }

    refute_nil tasks_json_by_id[task1.id]
    refute_nil tasks_json_by_id[task2.id]
  end

  test "#index responds with 200 when filtering by completed" do
    user = users(:one)

    task = create_task(user, name: "Foo", completed: true)

    get(api_v1_task_list_tasks_url(user.inbox, filter: "completed"), headers: api_v1_authorization_header(user))

    collection = assert_api_v1_response_with_success(:ok)

    assert_equal 1, collection.size

    assert_equal task.id, collection.first[:id]
  end

  test "#index responds with 200 when filtering by incomplete" do
    user = users(:one)

    task1 = user.inbox.tasks.first
    task2 = create_task(user, name: "Foo")
    task2.update_column(:completed_at, Time.current)

    get(api_v1_task_list_tasks_url(user.inbox, filter: "incomplete"), headers: api_v1_authorization_header(user))

    collection = assert_api_v1_response_with_success(:ok)

    assert_equal 1, collection.size

    assert_equal task1.id, collection.first[:id]
  end
end
