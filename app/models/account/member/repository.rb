# frozen_string_literal: true

module Account::Member::Repository
  extend self

  def find_user(member)
    return if member.invalid?

    account_id = member.task_list_id ? "task_lists.account_id" : "memberships.account_id"

    users_relation(member)
      .select("users.*, task_lists.id AS member_task_list_id, #{account_id} AS member_account_id").first
  end

  def find_task_lists(member)
    account_id = member.account_id

    Account::Task::List::Record.then { account_id ? _1.where(account_id:) : _1.none }
  end

  private

  def users_relation(member)
    return users_left_joins(member).where(users: {id: member.user_id}) if member.user_id?

    short, checksum = User::Token::Entity.parse(member.user_token).values_at(:short, :checksum)

    users_left_joins(member).joins(:token).where(user_tokens: {short: short.value, checksum:})
  end

  def users_left_joins(member)
    task_list_assignment = member.task_list_id ? ["id = ?", member.task_list_id] : "inbox = TRUE"
    task_lists_condition = "task_lists.#{sanitize_sql_for_assignment(task_list_assignment)}"

    membership_assignment = sanitize_sql_for_assignment(["account_id = ?", member.account_id]) if member.account_id
    memberships_condition = "AND memberships.#{membership_assignment}" if membership_assignment

    User::Record
      .joins("LEFT JOIN memberships ON users.id = memberships.user_id #{memberships_condition}")
      .joins("LEFT JOIN task_lists ON task_lists.account_id = memberships.account_id AND #{task_lists_condition}")
  end

  def sanitize_sql_for_assignment(...)
    ActiveRecord::Base.sanitize_sql_for_assignment(...)
  end
end
