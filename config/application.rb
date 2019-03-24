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
    config.autoload_paths << Rails.root.join('app/helpers/constants')
    config.exceptions_app = routes
    config.active_job.queue_adapter = :sidekiq

    # Verifies that versions and hashed value of the package contents in the project's package.json
    config.webpacker.check_yarn_integrity = false

    # Redis for caching.
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL_FOR_CACHING'] ||= 'redis://localhost:6379/10', expires_in: 1.day, namespace: 'app' }
  end
end
