# frozen_string_literal: true

class Account::Member
  include ActiveModel::API
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :user_token, :string
  attribute :user_id, :integer
  attribute :account_id, :integer
  attribute :task_list_id, :integer

  validates :user_token, presence: true, unless: :user_id?

  with_options numericality: {only_integer: true, greater_than: 0} do
    validates :user_id, presence: true, unless: :user_token?
    validates :account_id, allow_nil: true
    validates :task_list_id, allow_nil: true
  end

  validate :user_id_and_user_token_cannot_be_present_at_the_same_time

  def self.fetch_by(params)
    new(params).tap(&:user)
  end

  def user_token? = user_token.present?

  def user_id? = user_id.present?

  def account_id? = account_id.present?

  def task_list_id? = task_list_id.present?

  def user? = user.present?

  def account? = account.present?

  def task_list? = task_list.present?

  def authorized? = user.present? && account_id? && task_list_id?

  alias_method :persisted?, :authorized?

  def user
    return @user if defined?(@user)

    @user = users_first.tap do |user_record|
      self.user_id ||= user_record&.id
      self.account_id = user_record&.member_account_id
      self.task_list_id = user_record&.member_task_list_id
    end
  end

  def account
    return @account if defined?(@account)

    @account = account_id.try { user&.accounts&.find_by(id: _1) }
  end

  def task_list
    return @task_list if defined?(@task_list)

    @task_list = task_lists.find_by(id: task_list_id)
  end

  def task_lists
    return @task_lists if defined?(@task_lists)

    @task_lists = account_id ? TaskList.where(account_id:) : TaskList.none
  end

  private

  def user_id_and_user_token_cannot_be_present_at_the_same_time
    return unless user_id? && user_token?

    errors.add(:user_id, "cannot be present when user_token is present")
  end

  def users_first
    return if invalid?

    account_id = task_list_id ? "task_lists.account_id" : "memberships.account_id"

    users_relation.select("users.*, task_lists.id AS member_task_list_id, #{account_id} AS member_account_id").first
  end

  def users_relation
    return users_left_joins.where(users: {id: user_id}) if user_id?

    short, long = UserToken.parse_value(user_token)

    checksum = UserToken.checksum(short:, long:)

    users_left_joins.joins(:token).where(user_tokens: {short:, checksum:})
  end

  def users_left_joins
    task_list_assignment = task_list_id ? ["id = ?", task_list_id] : "inbox = TRUE"
    task_lists_condition = "task_lists.#{sanitize_sql_for_assignment(task_list_assignment)}"

    membership_assignment = sanitize_sql_for_assignment(["account_id = ?", account_id]) if account_id
    memberships_condition = "AND memberships.#{membership_assignment}" if membership_assignment

    User
      .joins("LEFT JOIN memberships ON users.id = memberships.user_id #{memberships_condition}")
      .joins("LEFT JOIN task_lists ON task_lists.account_id = memberships.account_id AND #{task_lists_condition}")
  end

  def sanitize_sql_for_assignment(...)
    ActiveRecord::Base.sanitize_sql_for_assignment(...)
  end
end
