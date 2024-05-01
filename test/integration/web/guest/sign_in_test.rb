# frozen_string_literal: true

require "test_helper"

class WebGuestSignInTest < ActionDispatch::IntegrationTest
  test "guest signs in with invalid data" do
    get(new_web_guest_session_url)

    assert_response :ok

    assert_select("h2", "Please sign in")

    params = {user: {email: "foo@", password: "123"}}

    post(web_guest_sessions_url, params:)

    assert_response :unprocessable_entity

    assert_select("h2", "Please sign in")

    assert_select(".alert", "Invalid email or password. Please try again.")
  end

  test "guest signs in with valid data" do
    params = {user: {email: users(:one).email, password: "123123123"}}

    post(web_guest_sessions_url, params:)

    assert_redirected_to web_task_items_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "You have successfully signed in!")

    assert User.exists?(email: params.dig(:user, :email), id: session[:user_id])
  end
end
