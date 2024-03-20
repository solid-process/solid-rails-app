# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :uuid, presence: true, uniqueness: true
end
