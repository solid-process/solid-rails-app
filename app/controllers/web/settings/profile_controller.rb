# frozen_string_literal: true

module Web::Settings
  class ProfileController < BaseController
    def show
      render "web/settings/profile"
    end
  end
end
