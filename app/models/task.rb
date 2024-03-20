# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :task_list

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }

  validates :name, presence: true
  validates :completed_at, presence: true, if: :completed?

  attr_accessor :completed

  before_validation do
    case completed
    when "1" then self.completed_at = Time.current
    when "0" then self.completed_at = nil
    end
  end

  after_initialize do
    self.completed = completed? ? "1" : "0"
  end

  def completed?
    completed_at.present?
  end

  def incomplete?
    !completed?
  end

  def complete!
    self.completed = "1"

    save!
  end

  def incomplete!
    self.completed = "0"

    save!
  end
end
