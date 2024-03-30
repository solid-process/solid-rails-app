# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.boolean :completed, default: false, null: false
      t.references :task_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
