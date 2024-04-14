# frozen_string_literal: true

class TaskList < ApplicationRecord
  belongs_to :account

  has_many :tasks, dependent: :destroy

  scope :inbox, -> { where(inbox: true) }
end
