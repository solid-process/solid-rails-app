# frozen_string_literal: true

require "test_helper"

class API::V1::User::PasswordsTest < ActionDispatch::IntegrationTest
  test "#update responds with 401 when access token is invalid" do
    headers = [{}, api_v1_authorization_header(SecureRandom.hex(20))].sample

    put(api_v1_user_passwords_url, params: {}, headers:)

    assert_api_v1_response_with_error(:unauthorized)
  end

  test "#update responds with 400 when params are missing" do
    user = users(:one)

    params = [{}, {user: {}}, {user: nil}].sample

    put(api_v1_user_passwords_url, params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:bad_request)
  end

  test "#update responds with 422 when password is invalid" do
    user = users(:one)

    current_password = ["", "123", "1234567"].sample
    password = ["", "123", "1234567"].sample
    password_confirmation = ["", "123", "1234567"].sample

    params = {user: {current_password:, password:, password_confirmation:}}

    put(api_v1_user_passwords_url, params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_error(:unprocessable_entity)
  end

  test "#update responds with 200 when params are valid" do
    user = users(:one)

    current_password = "123123123"
    password = "321321321"
    password_confirmation = "321321321"

    params = {user: {current_password:, password:, password_confirmation:}}

    put(api_v1_user_passwords_url, params:, headers: api_v1_authorization_header(user))

    assert_api_v1_response_with_success(:ok)
  end
end
