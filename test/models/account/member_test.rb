require "test_helper"

class Account::MemberTest < ActiveSupport::TestCase
  test "validations" do
    user_id = users(:one).id
    user_token = get_user_token(users(:one))

    member = Account::Member.new

    assert_not_predicate member, :valid?

    member.user_id = nil
    member.user_token = user_token

    assert_predicate member, :valid?

    member.user_id = user_id
    member.user_token = nil

    assert_predicate member, :valid?

    member.user_id = user_id
    member.user_token = user_token

    assert_not_predicate member, :valid?
  end

  test ".fetch_by with user_id" do
    user = users(:one)

    create_task_list(user.account, name: "Foo")

    member = Account::Member.fetch_by(user_id: user.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.account.id, member.account_id
    assert_equal user.inbox.id, member.task_list_id
    assert_equal user.id, member.user_id
    assert_nil member.user_token

    assert_equal user.account, member.account
    assert_equal user.inbox, member.task_list
    assert_equal user, member.user

    assert_equal user.task_lists, member.task_lists
    assert_equal 2, member.task_lists.size

    assert_predicate member, :user_id?
    assert_predicate member, :account_id?
    assert_predicate member, :task_list_id?

    assert_predicate member, :user?
    assert_predicate member, :account?
    assert_predicate member, :task_list?

    # ---

    user_id = User.maximum(:id) + 1

    member = Account::Member.fetch_by(user_id:)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_id, member.user_id
    assert_nil member.user
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.user_token
  end

  test ".fetch_by with user_id and account_id" do
    user = users(:one)
    account = accounts(:one)

    member = Account::Member.fetch_by(user_id: user.id, account_id: account.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.id, member.user_id
    assert_equal account.id, member.account_id
    assert_equal account.inbox.id, member.task_list_id
    assert_nil member.user_token

    # ---

    member = Account::Member.fetch_by(user_id: user.id, account_id: accounts(:two).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.id, member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.user_token

    # ---

    user_id = User.maximum(:id) + 1

    member = Account::Member.fetch_by(user_id:, account_id: account.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_id, member.user_id
    assert_nil member.user
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.user_token
  end

  test ".fetch_by with user_id and task_list_id" do
    user = users(:one)
    task_list = create_task_list(user.account, name: "Foo")

    member = Account::Member.fetch_by(user_id: user.id, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.id, member.user_id
    assert_equal task_list.id, member.task_list_id
    assert_equal task_list.account_id, member.account_id
    assert_nil member.user_token

    # ---

    member = Account::Member.fetch_by(user_id: user.id, task_list_id: task_lists(:two_inbox).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.id, member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.user_token

    # ---

    user_id = User.maximum(:id) + 1

    member = Account::Member.fetch_by(user_id:, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_id, member.user_id
    assert_nil member.user
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.user_token
  end

  test ".fetch_by with user_id, account_id, and task_list_id" do
    user = users(:one)
    account = accounts(:one)
    task_list = create_task_list(account, name: "Foo")

    member = Account::Member.fetch_by(user_id: user.id, account_id: account.id, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.id, member.user_id
    assert_equal account.id, member.account_id
    assert_equal task_list.id, member.task_list_id
    assert_nil member.user_token

    # ---

    member = Account::Member.fetch_by(user_id: user.id, account_id: accounts(:two).id, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.id, member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.user_token

    # ---

    task_list_id = task_lists(:two_inbox).id

    member = Account::Member.fetch_by(user_id: user.id, account_id: account.id, task_list_id:)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.id, member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.user_token
  end

  test ".fetch_by with user_token" do
    user = users(:one)
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(user_token:)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user_token, member.user_token
    assert_equal user.account.id, member.account_id
    assert_equal user.inbox.id, member.task_list_id
    assert_equal user.id, member.user_id
    assert_equal user, member.user

    # ---

    user_token = SecureRandom.hex

    member = Account::Member.fetch_by(user_token:)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_token, member.user_token
    assert_nil member.user
    assert_nil member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with user_token and account_id" do
    user = users(:one)
    account = accounts(:one)
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(user_token:, account_id: account.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.id, member.user_id
    assert_equal account.id, member.account_id
    assert_equal account.inbox.id, member.task_list_id

    # ---

    member = Account::Member.fetch_by(user_token:, account_id: accounts(:two).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.id, member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    member = Account::Member.fetch_by(user_token: SecureRandom.hex, account_id: account.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_nil member.user
    assert_nil member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with user_token and task_list_id" do
    user = users(:one)
    task_list = create_task_list(user.account, name: "Foo")
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(user_token:, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user_token, member.user_token
    assert_equal user.id, member.user_id
    assert_equal task_list.id, member.task_list_id
    assert_equal task_list.account_id, member.account_id

    # ---

    member = Account::Member.fetch_by(user_token:, task_list_id: task_lists(:two_inbox).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_token, member.user_token
    assert_equal user, member.user
    assert_equal user.id, member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    member = Account::Member.fetch_by(user_token: SecureRandom.hex, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    refute_nil member.user_token
    assert_nil member.user
    assert_nil member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with user_token, account_id, and task_list_id" do
    user = users(:one)
    account = accounts(:one)
    task_list = create_task_list(account, name: "Foo")
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(user_token:, account_id: account.id, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user_token, member.user_token
    assert_equal user.id, member.user_id
    assert_equal account.id, member.account_id
    assert_equal task_list.id, member.task_list_id

    # ---

    member = Account::Member.fetch_by(user_token:, account_id: accounts(:two).id, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_token, member.user_token
    assert_equal user, member.user
    assert_equal user.id, member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    member = Account::Member.fetch_by(user_token: SecureRandom.hex, account_id: account.id, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    refute_nil member.user_token
    assert_nil member.user
    assert_nil member.user_id
    assert_nil member.account_id
    assert_nil member.task_list_id
  end
end
