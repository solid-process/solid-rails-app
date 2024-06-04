# frozen_string_literal: true

class User::Entity
  include Solid::Model

  attribute :id, :integer
  attribute :uuid, :string
  attribute :email, :string

  def persisted?
    id.present?
  end
end
