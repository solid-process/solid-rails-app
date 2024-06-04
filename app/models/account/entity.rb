# frozen_string_literal: true

class Account::Entity
  include Solid::Model

  attribute :id, :integer

  def persisted?
    id.present?
  end
end
