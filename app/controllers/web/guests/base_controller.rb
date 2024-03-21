# frozen_string_literal: true

module Web::Guests
  class BaseController < ApplicationController
    layout "web/guest"

    before_action do
      redirect_to web_tasks_path if user_signed_in?
    end
  end
end
