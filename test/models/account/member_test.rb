require "test_helper"

class Account::MemberTest < ActiveSupport::TestCase
  test "validations" do
    user_uuid = users(:one).uuid
    user_token = get_user_token(users(:one))

    member = Account::Member.new

    assert_not_predicate member, :valid?

    member.uuid = nil
    member.token = user_token

    assert_predicate member, :valid?

    member.uuid = user_uuid
    member.token = nil

    assert_predicate member, :valid?

    member.uuid = user_uuid
    member.token = user_token

    assert_not_predicate member, :valid?
  end

  test ".fetch_by with uuid" do
    user = users(:one)
    record = account_members(:one)

    create_task_list(record.account, name: "Foo")

    member = Account::Member.fetch_by(uuid: user.uuid)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_nil member.token
    assert_equal user.uuid, member.uuid
    assert_equal record.account.id, member.account_id
    assert_equal record.inbox.id, member.task_list_id

    assert_equal user, member.user
    assert_equal record.inbox, member.task_list
    assert_equal record.account, member.account

    assert_equal record.task_lists, member.task_lists
    assert_equal 2, member.task_lists.size

    assert_predicate member, :uuid?
    assert_predicate member, :account_id?
    assert_predicate member, :task_list_id?

    assert_predicate member, :user?
    assert_predicate member, :account?
    assert_predicate member, :task_list?

    # ---

    uuid = ::UUID.generate

    member = Account::Member.fetch_by(uuid:)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.token
    assert_nil member.user
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with uuid and account_id" do
    user = users(:one)
    account = accounts(:one)

    member = Account::Member.fetch_by(uuid: user.uuid, account_id: account.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal account.inbox.id, member.task_list_id
    assert_nil member.token

    # ---

    member = Account::Member.fetch_by(uuid: user.uuid, account_id: accounts(:two).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.uuid, member.uuid
    assert_nil member.token
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    uuid = ::UUID.generate

    member = Account::Member.fetch_by(uuid:, account_id: account.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.user
    assert_nil member.token
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with uuid and task_list_id" do
    user = users(:one)
    record = account_members(:one)
    task_list = create_task_list(record.account, name: "Foo")

    member = Account::Member.fetch_by(uuid: user.uuid, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.uuid, member.uuid
    assert_equal task_list.id, member.task_list_id
    assert_equal task_list.account_id, member.account_id
    assert_nil member.token

    # ---

    member = Account::Member.fetch_by(uuid: user.uuid, task_list_id: task_lists(:two_inbox).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.token

    # ---

    uuid = ::UUID.generate

    member = Account::Member.fetch_by(uuid:, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.user
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.token
  end

  test ".fetch_by with uuid, account_id, and task_list_id" do
    user = users(:one)
    account = accounts(:one)
    task_list = create_task_list(account, name: "Foo")

    member = Account::Member.fetch_by(uuid: user.uuid, account_id: account.id, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal task_list.id, member.task_list_id
    assert_nil member.token

    # ---

    member = Account::Member.fetch_by(uuid: user.uuid, account_id: accounts(:two).id, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.token

    # ---

    task_list_id = task_lists(:two_inbox).id

    member = Account::Member.fetch_by(uuid: user.uuid, account_id: account.id, task_list_id:)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
    assert_nil member.token
  end

  test ".fetch_by with token" do
    user = users(:one)
    record = account_members(:one)
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(token: user_token)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user_token, member.token
    assert_equal record.account.id, member.account_id
    assert_equal record.inbox.id, member.task_list_id
    assert_equal user.uuid, member.uuid
    assert_equal user, member.user

    # ---

    user_token = SecureRandom.hex

    member = Account::Member.fetch_by(token: user_token)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_token, member.token
    assert_nil member.user
    assert_nil member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with token and account_id" do
    user = users(:one)
    account = accounts(:one)
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(token: user_token, account_id: account.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal account.inbox.id, member.task_list_id

    # ---

    member = Account::Member.fetch_by(token: user_token, account_id: accounts(:two).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user, member.user
    assert_equal user.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    member = Account::Member.fetch_by(token: SecureRandom.hex, account_id: account.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_nil member.user
    assert_nil member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with token and task_list_id" do
    user = users(:one)
    record = account_members(:one)
    task_list = create_task_list(record.account, name: "Foo")
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(token: user_token, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user_token, member.token
    assert_equal user.uuid, member.uuid
    assert_equal task_list.id, member.task_list_id
    assert_equal task_list.account_id, member.account_id

    # ---

    member = Account::Member.fetch_by(token: user_token, task_list_id: task_lists(:two_inbox).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_token, member.token
    assert_equal user, member.user
    assert_equal user.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    member = Account::Member.fetch_by(token: SecureRandom.hex, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    refute_nil member.token
    assert_nil member.user
    assert_nil member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with token, account_id, and task_list_id" do
    user = users(:one)
    account = accounts(:one)
    task_list = create_task_list(account, name: "Foo")
    user_token = get_user_token(user)

    member = Account::Member.fetch_by(token: user_token, account_id: account.id, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal user_token, member.token
    assert_equal user.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal task_list.id, member.task_list_id

    # ---

    member = Account::Member.fetch_by(token: user_token, account_id: accounts(:two).id, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal user_token, member.token
    assert_equal user, member.user
    assert_equal user.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    member = Account::Member.fetch_by(token: SecureRandom.hex, account_id: account.id, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    refute_nil member.token
    assert_nil member.user
    assert_nil member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end
end
