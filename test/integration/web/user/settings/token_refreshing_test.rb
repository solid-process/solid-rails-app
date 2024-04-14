# frozen_string_literal: true

require "test_helper"

class WebUserSettingsTokenRefreshingTest < ActionDispatch::IntegrationTest
  test "guest tries to access the API settings" do
    get(web_users_settings_api_url)

    assert_web_unauthorized_access
  end

  test "guest tries to refresh the access token" do
    put(web_users_tokens_url)

    assert_web_unauthorized_access
  end

  test "user tries to refresh the access token" do
    user = users(:one)

    web_sign_in(user)

    get(web_users_settings_api_url)

    assert_select("h2", "My API access token")

    assert_select("pre", user.token.access_token)

    assert_changes -> { user.token.reload.access_token } do
      put(web_users_tokens_url)
    end

    assert_redirected_to web_users_settings_api_url

    follow_redirect!

    assert_select(".notice", "Access token updated.")

    assert_select("pre", user.token.access_token)
  end
end
