ENV["RAILS_ENV"] ||= "test"

# SimpleCov configuration - must be loaded before application code
require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.start 'rails' do
  # Add coverage for all application code
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'

  # Configure formatters for both HTML and Cobertura XML reports
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter
  ])

  # Set minimum coverage threshold
  minimum_coverage 80

  # Refuse to merge results that are more than 10 minutes old
  merge_timeout 600

  # Coverage directory
  coverage_dir 'coverage'

  # Skip files that shouldn't be covered
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/db/'
  add_filter 'app/channels/application_cable/'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'

  # Track files even if they're never loaded
  track_files '{app,lib}/**/*.rb'
end

require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
