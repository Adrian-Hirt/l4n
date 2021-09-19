require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch

  add_group 'Operations', 'operations'
  add_group 'Queries', 'queries'
  add_group 'Services', 'services'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'pry-byebug'
require_relative 'test_data_factory'

class ApplicationTest < ActiveSupport::TestCase
  include ::TestDataFactory

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  def store(key, value)
    test_data[key] = value
  end

  def fetch(key)
    test_data[key]
  end

  private

  def test_data
    @test_data ||= {}
  end
end
