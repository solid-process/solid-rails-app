# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ItemsIndexTest < ActionDispatch::IntegrationTest
  test "#index responds with 401 when API token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    task_list = Account::Task::List::Record.inbox.first

    get(api_v1_task_list_items_url(task_list), headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#index responds with 404 when task list is not found" do
    user = users(:one)

    list_id = member_record(user).task_lists.maximum(:id) + 1

    get(api_v1_task_list_items_url(list_id), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#index responds with 404 when task list belongs to another user" do
    user = users(:one)

    task_list = member_record(users(:two)).task_lists.first

    get(api_v1_task_list_items_url(task_list), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#index responds with 200" do
    user = users(:one)

    task1 = member_record(user).inbox.task_items.first
    task2 = create_task(user, name: "Foo")
    task2.update_column(:completed_at, Time.current)

    get(api_v1_task_list_items_url(member_record(user).inbox), headers: api_v1_authorization_header(user))

    collection = assert_api_v1_response_with_success(:ok)

    assert_equal 2, collection.size

    tasks_json_by_id = collection.index_by { _1[:id] }

    refute_nil tasks_json_by_id[task1.id]
    refute_nil tasks_json_by_id[task2.id]
  end

  test "#index responds with 200 when filtering by completed" do
    user = users(:one)

    task = create_task(user, name: "Foo", completed: true)

    task_list = member_record(user).inbox

    get(api_v1_task_list_items_url(task_list, filter: "completed"), headers: api_v1_authorization_header(user))

    collection = assert_api_v1_response_with_success(:ok)

    assert_equal 1, collection.size

    assert_equal task.id, collection.first[:id]
  end

  test "#index responds with 200 when filtering by incomplete" do
    user = users(:one)

    task1 = member_record(user).inbox.task_items.first
    task2 = create_task(user, name: "Foo")
    task2.update_column(:completed_at, Time.current)

    task_list = member_record(user).inbox

    get(api_v1_task_list_items_url(task_list, filter: "incomplete"), headers: api_v1_authorization_header(user))

    collection = assert_api_v1_response_with_success(:ok)

    assert_equal 1, collection.size

    assert_equal task1.id, collection.first[:id]
  end
end
