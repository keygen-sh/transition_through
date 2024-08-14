# frozen_string_literal: true

require 'prism'

module TransitionThrough
  ##
  # TransitionExpression walks a Prism AST until we find a transition expression, e.g.:
  #
  #   expect { ... }.to transition { ... }.through [...]
  #
  # Returns the transition state in the transition block as a Result.
  class Expression < Prism::Visitor
    attr_reader :at, :result

    def initialize(at:) = @at = at

    # FIXME(ezekg) right now this only supports simple expressions, e.g. object.foo not object.foo(1).bar.
    def visit_call_node(node)
      case node
      in name: :transition, block: Prism::BlockNode(body: Prism::Node(body: [Prism::CallNode(receiver:, name: method_name)]), location:) if location.start_line == at
        @result = Result.new(receiver:, method_name:)
      else
        super
      end
    end

    private

    class Result
      attr_reader :receiver, :method_name

      def initialize(receiver:, method_name:)
        @receiver    = receiver
        @method_name = method_name
      end
    end
  end
end

