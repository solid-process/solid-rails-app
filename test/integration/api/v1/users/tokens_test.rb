# frozen_string_literal: true

require "test_helper"

class API::V1::Users::TokensTest < ActionDispatch::IntegrationTest
  test "#update responds with 401 when access token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    put(api_v1_users_tokens_url, headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#update refreshes user access token and responds with 200" do
    user = users(:one)

    assert_changes -> { user.token.reload.access_token } do
      put(api_v1_users_tokens_url, headers: api_v1_authorization_header(user))
    end

    json_data = assert_api_v1_response_with_success(:ok)

    access_token = user.token.access_token

    assert_equal 40, access_token.size
    assert_equal access_token, json_data["access_token"]
  end
end
