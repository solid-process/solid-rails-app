# frozen_string_literal: true

class TaskList < ApplicationRecord
  belongs_to :account

  has_many :task_items, dependent: :destroy

  scope :inbox, -> { where(inbox: true) }
end
