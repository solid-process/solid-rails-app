require "simplecov"
SimpleCov.start "rails" do
  add_filter "/lib/"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
    end

    parallelize_teardown do |worker|
      SimpleCov.result
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def create_task_list(account, name:)
      account.task_lists.create!(name: name)
    end

    def create_task(user, name:, completed: false, task_list: user.inbox)
      task = task_list.task_items.create!(name: "Foo")

      completed ? complete_task(task) : task
    end

    def complete_task(task)
      task.tap { _1.update_column(:completed_at, Time.current) }
    end

    def incomplete_task(task)
      task.tap { _1.update_column(:completed_at, nil) }
    end
  end
end

class ActionDispatch::IntegrationTest
  def web_sign_in(user, password: "123123123")
    post(web_guest_sessions_url, params: {user: {email: user.email, password:}})

    assert_redirected_to web_task_items_url

    follow_redirect!
  end

  def assert_web_unauthorized_access
    assert_redirected_to new_web_guest_session_path

    follow_redirect!

    assert_response :ok

    assert_select(".alert", "You need to sign in or sign up before continuing.")
  end

  def api_v1_authorization_header(arg)
    access_token = arg.is_a?(User) ? arg.token.access_token : arg.try(:access_token) || arg

    {"Authorization" => "Bearer #{access_token}"}
  end

  def assert_api_v1_response_with_error(status)
    assert_response(status)

    json_response = JSON.parse(response.body).with_indifferent_access

    assert_equal "error", json_response["status"]
    assert_kind_of String, json_response["message"]
    assert_kind_of Hash, json_response["details"]

    json_response
  end

  def assert_api_v1_response_with_success(status)
    assert_response(status)

    json_response = JSON.parse(response.body).with_indifferent_access

    assert_equal "success", json_response["status"]

    json_data = json_response["data"]

    case json_response["type"]
    when "object" then assert_kind_of(Hash, json_data)
    when "collection" then assert_kind_of(Array, json_data)
    else assert_equal(["status"], json_response.keys)
    end

    json_data
  end
end
