# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :task_list

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }

  def completed?
    completed_at.present?
  end

  def incomplete?
    !completed?
  end
end
