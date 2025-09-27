# Disable asset pipeline in test environment to avoid Sprockets issues
if Rails.env.test?
  Rails.application.config.assets.enabled = false
end