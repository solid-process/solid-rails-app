# frozen_string_literal: true

Rails.application.config.after_initialize do
  Solid::Adapters.configuration do |config|
    config.interface_enabled = Rails.env.local?
  end
end
