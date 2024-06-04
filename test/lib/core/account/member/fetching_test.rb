require "test_helper"

class Account::MemberTest < ActiveSupport::TestCase
  test ".call with uuid" do
    record = account_members(:one)

    create_task_list(record.account, name: "Foo")

    member = Account::Member::Fetching.call(uuid: record.uuid).fetch(:member)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal record.account.id, member.account_id
    assert_equal record.inbox.id, member.task_list_id

    assert_equal record.inbox.id, member.task_list.id
    assert_equal record.inbox.name, member.task_list.name
    assert_equal record.inbox.item_counter, member.task_list.item_counter

    assert_predicate member, :uuid?
    assert_predicate member, :account_id?
    assert_predicate member, :task_list_id?
    assert_predicate member, :task_list?

    # ---

    uuid = ::UUID.generate

    member = Account::Member::Fetching.call(uuid:).fetch(:member)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".call with uuid and account_id" do
    record = account_members(:one)
    account = accounts(:one)

    member = Account::Member::Fetching.call(uuid: record.uuid, account_id: account.id).fetch(:member)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal account.inbox.id, member.task_list_id

    # ---

    member = Account::Member::Fetching.call(uuid: record.uuid, account_id: accounts(:two).id).fetch(:member)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    uuid = ::UUID.generate

    member = Account::Member::Fetching.call(uuid:, account_id: account.id).fetch(:member)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".call with uuid and task_list_id" do
    record = account_members(:one)
    task_list = create_task_list(record.account, name: "Foo")

    member = Account::Member::Fetching.call(uuid: record.uuid, task_list_id: task_list.id).fetch(:member)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal task_list.id, member.task_list_id
    assert_equal task_list.account_id, member.account_id

    # ---

    member =
      Account::Member::Fetching.call(uuid: record.uuid, task_list_id: task_lists(:two_inbox).id).fetch(:member)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    uuid = ::UUID.generate

    member = Account::Member::Fetching.call(uuid:, task_list_id: task_list.id).fetch(:member)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".call with uuid, account_id, and task_list_id" do
    record = account_members(:one)
    account = accounts(:one)
    task_list = create_task_list(account, name: "Foo")

    member = Account::Member::Fetching
      .call(uuid: record.uuid, account_id: account.id, task_list_id: task_list.id)
      .fetch(:member)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal task_list.id, member.task_list_id

    # ---

    member = Account::Member::Fetching
      .call(uuid: record.uuid, account_id: accounts(:two).id, task_list_id: task_list.id)
      .fetch(:member)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    task_list_id = task_lists(:two_inbox).id

    member = Account::Member::Fetching
      .call(uuid: record.uuid, account_id: account.id, task_list_id:)
      .fetch(:member)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end
end
