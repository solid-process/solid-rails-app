# frozen_string_literal: true

class Account::Member::Entity
  include Solid::Model

  attr_accessor :task_list

  private :task_list=

  attribute :uuid, :string
  attribute :account_id, :integer
  attribute :task_list_id, :integer

  validates :uuid, presence: true, format: ::UUID::REGEXP

  with_options numericality: {only_integer: true, greater_than: 0} do
    validates :account_id, allow_nil: true
    validates :task_list_id, allow_nil: true
  end

  def uuid? = uuid.present?

  def account_id? = account_id.present?

  def task_list_id? = task_list_id.present?

  def task_list? = task_list.present?

  def authorized? = uuid? && account_id? && task_list.persisted?

  alias_method :persisted?, :authorized?
end
