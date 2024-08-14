# frozen_string_literal: true

require_relative 'transition_through/version'
require_relative 'transition_through/expression'
require_relative 'transition_through/matcher'
require_relative 'transition_through/methods'

module TransitionThrough
  class InvalidExpressionError < StandardError; end
end
