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

  setup do
    ::Operations::Admin::FeatureFlag::Reinitialize.run
    ::FeatureFlag.find_each do |flag|
      flag.update(enabled: true)
    end
  end

  def store(key, value)
    test_data[key] = value
  end

  def fetch(key)
    test_data[key]
  end

  # Usage of the below methods:
  #
  # as_user ::User.first do
  #   op = build_op ::Operations::Event::Index
  #   assert op.respond_to?(:events)
  # end
  #
  # The cases for the run_op and run_op! are similar
  def as_user(user)
    @context = RailsOps::Context.new(user: user, ability: Ability.new(user))
    yield
  ensure
    @context = nil
  end

  def run_op(operation, *args)
    fail 'Can only be used within the `as_user` block' if @context.nil?

    @context.run operation, *args
  end

  def run_op!(operation, *args)
    fail 'Can only be used within the `as_user` block' if @context.nil?

    @context.run! operation, *args
  end

  def build_op(operation, *args)
    fail 'Can only be used within the `as_user` block' if @context.nil?

    operation.new(@context, *args)
  end

  private

  def test_data
    @test_data ||= {}
  end
end
