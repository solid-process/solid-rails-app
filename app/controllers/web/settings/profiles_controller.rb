# frozen_string_literal: true

module Web::Settings
  class ProfilesController < BaseController
    def show
      render "web/settings/profile"
    end
  end
end
