# frozen_string_literal: true

require "test_helper"

class WebUserSettingsAccountDeletionTest < ActionDispatch::IntegrationTest
  test "guest account deletion" do
    delete(web_user_registrations_url)

    assert_web_unauthorized_access
  end

  test "user account deletion" do
    user = users(:one)

    web_sign_in(user)

    get(web_user_settings_profile_url)

    assert_select("h2", "Account deletion")
    assert_select("button", "Delete account")

    assert_difference(
      -> { User::Record.count } => -1,
      -> { Account::Record.count } => -1,
      -> { Account::Membership::Record.count } => -1,
      -> { Account::Task::List::Record.count } => -1,
      -> { User::Token::Record.count } => -1
    ) do
      delete(web_user_registrations_url)
    end

    assert_redirected_to root_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Your account has been deleted.")

    assert_nil User::Record.find_by(id: user.id)
  end
end
