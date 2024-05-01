# frozen_string_literal: true

require "test_helper"

class WebUserSignOutTest < ActionDispatch::IntegrationTest
  test "guest signs out" do
    delete(web_user_sessions_url)

    assert_web_unauthorized_access
  end

  test "user signs out" do
    user = users(:one)

    web_sign_in(user)

    delete(web_user_sessions_url)

    assert_redirected_to new_web_guest_session_path

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "You have successfully signed out.")
  end
end
