# frozen_string_literal: true

class TaskList < ApplicationRecord
  include Inbox

  has_many :tasks, dependent: :destroy
  belongs_to :account
end
