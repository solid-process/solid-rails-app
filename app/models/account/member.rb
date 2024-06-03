# frozen_string_literal: true

class Account::Member
  include ActiveSupport::Configurable
  include Solid::Model

  config_accessor :repository, default: Repository

  attribute :uuid, :string
  attribute :account_id, :integer
  attribute :task_list_id, :integer

  validates :uuid, presence: true, format: ::UUID::REGEXP

  with_options numericality: {only_integer: true, greater_than: 0} do
    validates :account_id, allow_nil: true
    validates :task_list_id, allow_nil: true
  end

  validates :repository, respond_to: [:find_record, :find_account!, :find_task_lists]

  def self.fetch_by(params)
    new(params).tap(&:authorized?)
  end

  def uuid? = uuid.present?

  def account_id? = account_id.present?

  def task_list_id? = task_list_id.present?

  def account? = account.present?

  def task_list? = task_list.present?

  def authorized? = record.present? && account_id? && task_list_id?

  alias_method :persisted?, :authorized?

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

  def record
    return @record if defined?(@record)

    @record = repository.find_record(self).fetch(:member, nil).tap do
      self.uuid ||= _1&.uuid
      self.account_id = _1&.member_account_id
      self.task_list_id = _1&.member_task_list_id
    end
  end
end
