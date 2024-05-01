# frozen_string_literal: true

require "test_helper"

class API::V1::Task::ListsIndexTest < ActionDispatch::IntegrationTest
  test "#index responds with 401 when access token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    get(api_v1_task_lists_url, headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#index responds with 200" do
    user = users(:one)

    new_task_list = user.account.task_lists.create!(name: "Foo")

    get(api_v1_task_lists_url, headers: api_v1_authorization_header(user))

    collection = assert_api_v1_response_with_success(:ok)

    assert_equal 2, collection.size

    assert collection.all? { user.task_lists.exists?(_1[:id]) }

    assert_equal new_task_list.id, collection.first[:id]
  end
end
