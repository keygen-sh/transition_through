# frozen_string_literal: true

require 'rspec'
require 'rspec/mocks/standalone'

require_relative 'expression'

module TransitionThrough
  class Matcher
    include RSpec::Matchers, RSpec::Matchers::Composable, RSpec::Mocks::ExampleMethods

    attr_reader :state_block

    def initialize(state_block)
      @state_block     = state_block
      @expected_states = []
      @actual_states   = []
    end

    def supports_block_expectations? = true
    def matches?(expect_block)
      raise InvalidExpressionError, 'transition block is required' if state_block.nil?

      path, start_line = state_block.source_location

      # walk the ast until we find our transition expression
      exp = Expression.new(at: start_line)
      ast = Prism.parse_file(path)

      ast.value.accept(exp)

      # raise if the expression is  too complex or empty
      raise InvalidExpressionError, 'complex or empty transition expressions are not supported' if
        exp.result.nil? || exp.result.receiver.nil? || exp.result.method_name.nil?

      # get the actual transitioning object from the state block's binding
      receiver = state_block.binding.eval(exp.result.receiver.name.to_s)

      raise InvalidExpressionError, "expected accessor #{receiver.class}##{exp.result.method_name} but it's missing" unless
        receiver.respond_to?(:"#{exp.result.method_name}=") &&
        receiver.respond_to?(exp.result.method_name)

      # get the receiver's methods for stubbing
      setter = receiver.method(:"#{exp.result.method_name}=")
      getter = receiver.method(exp.result.method_name)

      # record initial state via getter
      @expected_states = @actual_states = [getter.call]

      # stub the setter so that we can track state transitions
      allow(receiver).to receive(setter.name) do |value|
        @actual_states << value

        setter.call(value)
      end

      # call the expect block
      expect_block.call

      # assert states match
      @actual_states == @expected_states
    end

    def through(*values)
      @expected_states = values.flatten(1)

      self
    end

    def failure_message
      "expected block to transition through #{@expected_states.inspect} but it transitioned through #{@actual_states.inspect}"
    end

    def failure_message_when_negated
      "expected block not to transition through #{@expected_states.inspect} but it did"
    end
  end
end

