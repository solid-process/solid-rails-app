# frozen_string_literal: true

module Web::Guest
  class BaseController < Web::BaseController
    layout "web/guest"

    before_action do
      redirect_to web_task_items_path if user_signed_in?
    end
  end
end
