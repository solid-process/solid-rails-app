# frozen_string_literal: true

class Account::Task::List::Entity
  include Solid::Model

  attribute :id, :integer
  attribute :name, :string
  attribute :inbox, :boolean
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :item_counter, :integer

  def persisted?
    id.present?
  end

  def inbox?
    inbox
  end
end
