require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TabletalkApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.action_cable.url = ENV['CABLE_URI']
    config.action_cable.allowed_request_origins = [
      'http://localhost:8080',
      'http://rose.local:8080',
      'https://agile-reef-36732.herokuapp.com',
      'https://table-talk.herokuapp.com'
    ]

    config.middleware.insert_before 'Rack::Runtime', 'Rack::Cors' do
      allow do
        origins '*'
        resource '*',
        headers: :any,
        methods: [:get, :put, :post, :patch, :delete, :options]
      end
    end

    config.autoload_paths << Rails.root.join('app/classes/**/')
  end
end
