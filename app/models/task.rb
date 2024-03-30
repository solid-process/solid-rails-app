# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :task_list

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  def complete!
    update!(completed: true)
  end

  def incomplete!
    update!(completed: false)
  end
end
