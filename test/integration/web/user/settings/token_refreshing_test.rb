# frozen_string_literal: true

require "test_helper"

class WebUserSettingsTokenRefreshingTest < ActionDispatch::IntegrationTest
  test "guest tries to access the API settings" do
    get(web_user_settings_api_url)

    assert_web_unauthorized_access
  end

  test "guest tries to refresh the API token" do
    put(web_user_tokens_url)

    assert_web_unauthorized_access
  end

  test "user tries to refresh the API token" do
    user = users(:one)

    web_sign_in(user)

    get(web_user_settings_api_url)

    assert_select("h2", "My API token")

    assert_select("pre", user.token.value)

    assert_changes -> { user.token.reload.value } do
      put(web_user_tokens_url)
    end

    assert_redirected_to web_user_settings_api_url

    follow_redirect!

    assert_select(".notice", "API token updated.")

    assert_select("pre", /#{user.token.short}_.{32}/)
  end
end
