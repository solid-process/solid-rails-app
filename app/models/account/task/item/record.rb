# frozen_string_literal: true

module Account::Task
  class Item::Record < ApplicationRecord
    self.table_name = "task_items"

    belongs_to :task_list, inverse_of: :task_items, class_name: "List::Record"

    scope :completed, -> { where.not(completed_at: nil) }
    scope :incomplete, -> { where(completed_at: nil) }

    def completed?
      completed_at.present?
    end

    def incomplete?
      !completed?
    end
  end
end
