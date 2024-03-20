# frozen_string_literal: true

module Web::Settings
  class BaseController < ApplicationController
    layout "web/application"

    before_action :authenticate_user!
  end
end
