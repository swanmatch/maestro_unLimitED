require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
#require File.expand_path("../../lib/log4r.rb", __FILE__)
#include Log4r

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MaestroUnlimited
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.colorize_logging = false
#    require File.dirname(__FILE__) + "/../lib/custom_logger"
    config.logger = nil if Rails.env.production?

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators.template_engine = :erb
    config.enable_dependency_loading = true
    config.autoload_paths << Rails.root.join("lib")
    config.generators do |g|
      g.orm :active_record
      g.assets false
      g.helper false
    end
  end
end
