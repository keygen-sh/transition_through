# frozen_string_literal: true

require_relative 'lib/transition_through/version'

Gem::Specification.new do |spec|
  spec.name        = 'transition_through'
  spec.version     = TransitionThrough::VERSION
  spec.authors     = ['Zeke Gabrielse']
  spec.email       = ['oss@keygen.sh']
  spec.summary     = 'Assert state changes in sequence. Like change{}, but for asserting multiple changes in RSpec.'
  spec.description = 'Assert state changes through multiple values for an object, enabling you to test complex state transitions in sequence.'
  spec.homepage    = 'https://github.com/keygen-sh/transition_through'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 3.1'
  spec.files                 = %w[LICENSE CHANGELOG.md CONTRIBUTING.md SECURITY.md README.md] + Dir.glob('lib/**/*')
  spec.require_paths         = ['lib']

  spec.add_dependency 'rails', '>= 6.0'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'temporary_tables', '~> 1.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
  spec.add_development_dependency 'prism'
end
