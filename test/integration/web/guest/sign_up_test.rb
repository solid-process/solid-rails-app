# frozen_string_literal: true

require "test_helper"

class WebGuestSignUpTest < ActionDispatch::IntegrationTest
  test "guest signs up with invalid data" do
    get(new_web_guest_registration_url)

    assert_response :ok

    assert_select("h2", "Sign up")

    params = {guest: {email: "foo@", password: "123", password_confirmation: "321"}}

    post(web_guest_registrations_url, params:)

    assert_response :unprocessable_entity

    assert_select("h2", "Sign up")

    assert_select("li", "Email is invalid")
    assert_select("li", "Password is too short (minimum is 8 characters)")
    assert_select("li", "Password confirmation doesn't match Password")
  end

  test "guest signs up with an email that is already taken" do
    params = {
      guest: {
        email: users(:one).email,
        password: "123123123",
        password_confirmation: "123123123"
      }
    }

    post(web_guest_registrations_url, params:)

    assert_response :unprocessable_entity

    assert_select("h2", "Sign up")

    assert_select("li", "Email has already been taken")
  end

  test "guest signs up with valid data" do
    params = {
      guest: {
        email: "email@example.com",
        password: "123123123",
        password_confirmation: "123123123"
      }
    }

    assert_difference(
      -> { User::Record.count } => 1,
      -> { Account::Record.count } => 1,
      -> { Account::Membership::Record.count } => 1,
      -> { Account::Task::List::Record.count } => 1,
      -> { User::Token::Record.count } => 1
    ) do
      post(web_guest_registrations_url, params:)
    end

    assert_redirected_to web_task_items_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "You have successfully registered!")

    assert User::Record.exists?(email: params.dig(:guest, :email), uuid: session[:user_uuid])
  end
end
