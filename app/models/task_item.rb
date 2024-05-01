# frozen_string_literal: true

class TaskItem < ApplicationRecord
  belongs_to :task_list

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }

  before_validation :set_completed_at, if: :completed_changed?

  def complete!
    update! completed: true
  end

  def incomplete!
    update! completed: false
  end

  private

  def set_completed_at
    self.completed_at = completed? ? Time.current : nil
  end
end
