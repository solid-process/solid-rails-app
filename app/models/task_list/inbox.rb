module TaskList::Inbox
  extend ActiveSupport::Concern

  included do
    before_validation :set_inbox_name, if: :inbox?
    scope :inbox, -> { where(inbox: true) }
  end

  private

  def set_inbox_name
    self.name = "Inbox"
  end
end
