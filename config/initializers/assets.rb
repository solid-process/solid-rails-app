# frozen_string_literal: true

[
  Rails.root.join("vendor/stylesheets")
].each do |path|
  Rails.application.config.assets.paths << path
end
