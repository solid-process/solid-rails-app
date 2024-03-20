# frozen_string_literal: true

class TaskList < ApplicationRecord
  belongs_to :account

  has_many :tasks, dependent: :destroy

  scope :inbox, -> { where(inbox: true) }

  validates :name, presence: true
  validates :inbox, uniqueness: {scope: :account_id}, if: :inbox?

  before_validation :set_inbox_name, if: :inbox?

  private

  def set_inbox_name
    self.name = "Inbox"
  end
end
