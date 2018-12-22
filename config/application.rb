require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Strafforts
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.eager_load_paths << Rails.root.join('lib')
    config.exceptions_app = routes
    config.active_job.queue_adapter = :delayed_job

    # Verifies that versions and hashed value of the package contents in the project's package.json
    config.webpacker.check_yarn_integrity = false

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.logger    = ActiveSupport::TaggedLogging.new(logger)
      config.log_level = ENV["RAILS_LOG_LEVEL"].present? ? ENV['RAILS_LOG_LEVEL'].to_sym : :info
    end
  end
end
