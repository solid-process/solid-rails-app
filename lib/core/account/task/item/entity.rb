# frozen_string_literal: true

class Account::Task::Item::Entity
  include Solid::Model

  attribute :id, :integer
  attribute :name, :string
  attribute :completed_at, :datetime
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :task_list_id, :integer

  def persisted?
    id.present?
  end

  def completed?
    completed_at.present?
  end

  def incomplete?
    !completed?
  end
end
