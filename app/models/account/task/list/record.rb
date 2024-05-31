# frozen_string_literal: true

module Account::Task
  class List::Record < ApplicationRecord
    self.table_name = "task_lists"

    belongs_to :account, inverse_of: :task_lists, class_name: "Account::Record"

    has_many :task_items, dependent: :destroy, inverse_of: :task_list, class_name: "Item::Record"

    scope :inbox, -> { where(inbox: true) }
  end
end
