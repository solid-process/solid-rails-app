# frozen_string_literal: true

class Account::Member
  module Repository
    extend Solid::Output.mixin
    extend self

    def create!(uuid:)
      member = Record.create!(uuid:)

      Success(:member_created, member:)
    rescue ::ActiveRecord::RecordNotUnique
      Failure(:uuid_has_already_been_taken)
    end

    def create_account!(member:, uuid: ::UUID.generate)
      account = Account::Record.create!(uuid:)

      account.memberships.create!(member:, role: :owner)

      Success(:account_created, account:)
    rescue ::ActiveRecord::RecordNotUnique
      Failure(:uuid_has_already_been_taken)
    end

    def destroy_account!(uuid:)
      member = Record.find_by!(uuid:)

      member.transaction do
        member.account.destroy!
        member.destroy!
      end

      Success(:member_deleted, member:, account: member.account)
    end

    def find_record(member)
      return Failure(:invalid_member) if member.invalid?

      member = members_relation(member).first

      member ? Success(:member_found, member:) : Failure(:member_not_found)
    end

    def find_account!(member)
      member.account_id.try { Account::Record.find(_1) }
    end

    def find_task_lists(member)
      account_id = member.account_id

      Account::Task::List::Record.then { account_id ? _1.where(account_id:) : _1.none }
    end

    private

    def members_relation(member)
      task_list_assignment = member.task_list_id ? ["id = ?", member.task_list_id] : "inbox = TRUE"
      task_lists_condition = "task_lists.#{sanitize_sql_for_assignment(task_list_assignment)}"

      membership_assignment = sanitize_sql_for_assignment(["account_id = ?", member.account_id]) if member.account_id
      memberships_condition = "AND memberships.#{membership_assignment}" if membership_assignment

      account_id = member.task_list_id ? "task_lists.account_id" : "memberships.account_id"

      Record
        .select("account_members.*, task_lists.id AS member_task_list_id, #{account_id} AS member_account_id")
        .joins("LEFT JOIN memberships ON account_members.id = memberships.member_id #{memberships_condition}")
        .joins("LEFT JOIN task_lists ON task_lists.account_id = memberships.account_id AND #{task_lists_condition}")
        .where(account_members: {uuid: member.uuid})
    end

    def sanitize_sql_for_assignment(...)
      ActiveRecord::Base.sanitize_sql_for_assignment(...)
    end
  end
end
