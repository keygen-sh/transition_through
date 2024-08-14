# frozen_string_literal: true

require_relative 'matcher'

module TransitionThrough
  module Methods
    def transition(&block) = Matcher.new(block)
  end
end

