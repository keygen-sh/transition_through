# frozen_string_literal: true

require 'transition_through'
require 'temporary_tables'
require 'active_support'
require 'active_record'
require 'rails'
require 'sqlite3'
require 'logger'

require 'rspec/mocks/standalone'
require 'prism'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:',
)

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.configure do |config|
  config.include TransitionThrough::Methods
  config.include TemporaryTables::Methods

  config.expect_with(:rspec) { _1.syntax = :expect }
  config.disable_monkey_patching!
end
