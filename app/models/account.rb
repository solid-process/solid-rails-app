# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :task_lists, dependent: :destroy
  has_many :tasks, through: :task_lists

  has_one :ownership, -> { owner }, class_name: "Membership", inverse_of: :account, dependent: nil
  has_one :inbox, -> { inbox }, class_name: "TaskList", inverse_of: :account, dependent: nil
  has_one :owner, through: :ownership, source: :user

  validates :uuid, presence: true, uniqueness: true
end
