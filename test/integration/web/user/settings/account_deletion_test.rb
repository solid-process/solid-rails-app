# frozen_string_literal: true

require "test_helper"

class WebUserSettingsAccountDeletionTest < ActionDispatch::IntegrationTest
  test "guest signs out" do
    delete(web_users_registrations_url)

    assert_web_unauthorized_access
  end

  test "user signs out" do
    user = users(:one)

    web_sign_in(user)

    get(web_users_settings_profile_url)

    assert_select("h2", "Account deletion")
    assert_select("button", "Delete account")

    assert_difference(
      -> { User.count } => -1,
      -> { Account.count } => -1,
      -> { Membership.count } => -1,
      -> { TaskList.count } => -1,
      -> { UserToken.count } => -1
    ) do
      delete(web_users_registrations_url)
    end

    assert_redirected_to root_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Your account has been deleted.")

    assert_nil User.find_by(id: user.id)
  end
end
