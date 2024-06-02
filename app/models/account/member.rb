# frozen_string_literal: true

class Account::Member
  include ActiveSupport::Configurable
  include Solid::Model

  config_accessor :repository, default: Repository

  attribute :uuid, :string
  attribute :token, :string
  attribute :account_id, :integer
  attribute :task_list_id, :integer

  validates :uuid, presence: true, format: ::UUID::REGEXP, unless: :token?
  validates :token, presence: true, unless: :uuid?

  with_options numericality: {only_integer: true, greater_than: 0} do
    validates :account_id, allow_nil: true
    validates :task_list_id, allow_nil: true
  end

  validate :uuid_and_token_cannot_be_present_at_the_same_time

  validates :repository, respond_to: [:find_user, :find_account!, :find_task_lists]

  def self.fetch_by(params)
    new(params).tap(&:user)
  end

  def uuid? = uuid.present?

  def token? = token.present?

  def account_id? = account_id.present?

  def task_list_id? = task_list_id.present?

  def user? = user.present?

  def account? = account.present?

  def task_list? = task_list.present?

  def authorized? = user.present? && account_id? && task_list_id?

  alias_method :persisted?, :authorized?

  def user
    return @user if defined?(@user)

    @user = repository.find_user(self).tap do |user_record|
      self.uuid ||= user_record&.uuid
      self.account_id = user_record&.member_account_id
      self.task_list_id = user_record&.member_task_list_id
    end
  end

  def account
    return @account if defined?(@account)

    @account = repository.find_account!(self)
  end

  def task_list
    return @task_list if defined?(@task_list)

    @task_list = task_lists.find_by(id: task_list_id)
  end

  def task_lists
    return @task_lists if defined?(@task_lists)

    @task_lists = repository.find_task_lists(self)
  end

  private

  def uuid_and_token_cannot_be_present_at_the_same_time
    return unless uuid? && token?

    errors.add(:uuid, "cannot be present when token is present")
    errors.add(:token, "cannot be present when uuid is present")
  end
end
