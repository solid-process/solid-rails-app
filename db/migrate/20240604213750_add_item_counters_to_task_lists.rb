class AddItemCountersToTaskLists < ActiveRecord::Migration[7.1]
  def change
    add_column :task_lists, :item_counter, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        Account::Task::List::Record.find_each do |task_list|
          task_list.update!(item_counter: task_list.task_items.count)
        end
      end
    end
  end
end
