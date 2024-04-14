# frozen_string_literal: true

require "test_helper"

class WebTaskItemsTest < ActionDispatch::IntegrationTest
  test "guest tries to access all tasks" do
    get(web_tasks_url)

    assert_web_unauthorized_access
  end

  test "guest tries to access completed tasks" do
    get(completed_web_tasks_url)

    assert_web_unauthorized_access
  end

  test "guest tries to access incomplete tasks" do
    get(incomplete_web_tasks_url)

    assert_web_unauthorized_access
  end

  test "user access all tasks" do
    user = users(:one)

    create_task(user, name: "Foo", completed: true)

    web_sign_in(user)

    get(web_tasks_url)

    assert_response :ok

    assert_select("p", /All \(2\)/)

    assert_equal 1, css_select("button[title=\"Mark as complete\"]").size
    assert_equal 1, css_select("button[title=\"Mark as incomplete\"]").size

    links = css_select("[data-confirm=\"Are you sure you want to delete this task?\"]")

    assert_equal 2, links.size

    links.each do |link|
      delete(link["href"])

      assert_redirected_to web_tasks_url

      follow_redirect!

      assert_response :ok
    end

    assert_equal 0, css_select("[data-method=\"put\"]").size

    assert_select(".notice", "You don't have any tasks. Create one by touching the \"+ New\" button.")
  end

  test "user access completed tasks" do
    user = users(:one)

    tasks(:one).then { complete_task(_1) }

    web_sign_in(user)

    get(completed_web_tasks_url)

    assert_response :ok

    assert_select("p", /Completed \(1\)/)

    links = css_select("[data-method=\"put\"]")

    assert_equal 1, links.size

    link = links.first

    assert_equal("button", link.child.name)
    assert_equal("Mark as incomplete", link.child["title"])

    put(link["href"])

    assert_redirected_to completed_web_tasks_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task marked as incomplete")

    assert_equal 0, css_select("[data-method=\"put\"]").size

    assert_select(".notice", "You don't have any completed tasks. Keep up the good work!")

    get(incomplete_web_tasks_url)

    links = css_select("[data-confirm=\"Are you sure you want to delete this task?\"]")

    assert_equal 1, links.size

    delete(links.first["href"])

    assert_redirected_to incomplete_web_tasks_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task deleted")

    assert_equal 0, css_select("[data-method=\"put\"]").size

    assert_select(".notice", "You don't have any tasks. Create one by touching the \"+ New\" button.")
  end

  test "user access incomplete tasks" do
    user = users(:one)

    web_sign_in(user)

    get(incomplete_web_tasks_url)

    assert_response :ok

    assert_select("p", /Incomplete \(1\)/)

    links = css_select("[data-method=\"put\"]")

    assert_equal 1, links.size

    link = links.first

    assert_equal("button", link.child.name)
    assert_equal("Mark as complete", link.child["title"])

    put(link["href"])

    assert_redirected_to incomplete_web_tasks_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task marked as completed")

    assert_equal 0, css_select("[data-method=\"put\"]").size

    assert_select(".notice", "You don't have any incomplete tasks. Great job!")

    get(completed_web_tasks_url)

    links = css_select("[data-confirm=\"Are you sure you want to delete this task?\"]")

    assert_equal 1, links.size

    delete(links.first["href"])

    assert_redirected_to completed_web_tasks_url

    follow_redirect!

    assert_response :ok

    assert_select(".notice", "Task deleted")

    assert_equal 0, css_select("[data-method=\"put\"]").size

    assert_select(".notice", "You don't have any tasks. Create one by touching the \"+ New\" button.")
  end
end
