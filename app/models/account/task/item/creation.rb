# frozen_string_literal: true

module Account::Task
  class Item::Creation < Solid::Process
    deps do
      attribute :repository, default: Item::Repository

      validates :repository, respond_to: [:create!]
    end

    input do
      attribute :name, :string
      attribute :task_list

      before_validation do
        self.name = name&.strip
      end

      validates :name, presence: true
      validates :task_list, instance_of: List::Entity
    end

    def call(attributes)
      case deps.repository.create!(**attributes)
      in Solid::Failure(:task_list_not_found, _)
        Failure(:task_list_not_found)
      in Solid::Success(task:)
        Success(:task_created, task:)
      end
    end
  end
end
