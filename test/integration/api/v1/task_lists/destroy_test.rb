# frozen_string_literal: true

require "test_helper"

class API::V1::TaskListsDestroyTest < ActionDispatch::IntegrationTest
  test "#destroy responds with 401 when access token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    delete(api_v1_task_list_url(task_lists(:one_inbox)), headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#destroy responds with 404 when task list is not found" do
    user = users(:one)

    delete(api_v1_task_list_url(TaskList.maximum(:id) + 1), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:not_found)
  end

  test "#destroy responds with 403 when trying to destroy the inbox task list" do
    user = users(:one)

    delete(api_v1_task_list_url(task_lists(:one_inbox)), headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:forbidden)
  end

  test "#destroy responds with 204" do
    user = users(:one)

    task_list = user.account.task_lists.create!(name: "Bar")

    assert_difference -> { user.account.task_lists.count }, -1 do
      delete(api_v1_task_list_url(task_list), headers: api_v1_authorization_header(user))
    end

    assert_api_v1_response_with_success(:ok)
  end
end
