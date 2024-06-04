# frozen_string_literal: true

require "test_helper"

class API::V1::User::TokensTest < ActionDispatch::IntegrationTest
  test "#update responds with 401 when API token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    put(api_v1_user_tokens_url, headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#update refreshes user API token and responds with 200" do
    user = users(:one)

    assert_changes -> { user.token.reload.short } do
      put(api_v1_user_tokens_url, headers: api_v1_authorization_header(user))
    end

    json_data = assert_api_v1_response_with_success(:ok)

    assert_equal 8, user.token.short.size
    assert_equal user.token.short, json_data["user_token"].split("_").first
  end
end
