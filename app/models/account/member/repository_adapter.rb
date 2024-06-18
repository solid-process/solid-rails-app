# frozen_string_literal: true

module Account::Member
  module RepositoryAdapter
    extend Adapters::RepositoryInterface
    extend Solid::Output.mixin
    extend self

    def create!(uuid:)
      Record.create!(uuid:)

      Success(:member_created, member: Entity.new(uuid:))
    rescue ::ActiveRecord::RecordNotUnique
      Failure(:uuid_has_already_been_taken)
    end

    def create_account!(member:, uuid:)
      member_record = Record.find_by!(uuid: member.uuid)

      account_record = Account::Record.create!(uuid:)

      account_record.memberships.create!(member: member_record, role: :owner)

      account = Account::Entity.new(id: account_record.id)

      Success(:account_created, account:)
    rescue ::ActiveRecord::RecordNotUnique
      Failure(:uuid_has_already_been_taken)
    end

    def destroy_account!(uuid:)
      record = Record.find_by!(uuid:)

      record.transaction do
        record.account.destroy!
        record.destroy!
      end

      member = Entity.new(uuid:)
      account = Account::Entity.new(id: record.account.id)

      Success(:member_deleted, member:, account:)
    end

    def find_including_task_list(uuid:, account_id:, task_list_id:)
      member = Entity.new(uuid:, account_id:, task_list_id:)

      return Failure(:invalid_member, member:) if member.invalid?

      record = members_relation(member).first

      member.account_id = record&.member_account_id
      member.task_list_id = record&.member_task_list_id

      if record&.member_task_list_id
        task_list = Account::Task::List::Entity.new(
          id: record.member_task_list_id,
          name: record.member_task_list_name,
          item_counter: record.member_task_list_item_counter
        )

        member.send(:task_list=, task_list)
      end

      record ? Success(:member_found, member:) : Failure(:member_not_found, member:)
    end

    private

    def members_relation(member)
      task_list_assignment = member.task_list_id ? ["id = ?", member.task_list_id] : "inbox = TRUE"
      task_lists_condition = "task_lists.#{sanitize_sql_for_assignment(task_list_assignment)}"

      membership_assignment = sanitize_sql_for_assignment(["account_id = ?", member.account_id]) if member.account_id
      memberships_condition = "AND memberships.#{membership_assignment}" if membership_assignment

      account_id = member.task_list_id ? "task_lists.account_id" : "memberships.account_id"

      columns = "account_members.*, " \
                "#{account_id} AS member_account_id, " \
                "task_lists.id AS member_task_list_id, " \
                "task_lists.name AS member_task_list_name, " \
                "task_lists.item_counter AS member_task_list_item_counter"

      Record
        .select(columns)
        .joins("LEFT JOIN memberships ON account_members.id = memberships.member_id #{memberships_condition}")
        .joins("LEFT JOIN task_lists ON task_lists.account_id = memberships.account_id AND #{task_lists_condition}")
        .where(account_members: {uuid: member.uuid})
    end

    def sanitize_sql_for_assignment(...)
      ActiveRecord::Base.sanitize_sql_for_assignment(...)
    end
  end
end
