# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TransitionThrough do
  let(:counter) { Counter.new }

  context 'using methods' do
    temporary_model :counter, table_name: nil, base_class: nil do
      attr_accessor :count

      def initialize       = self.count = 0
      def increment(n = 1) = n.times { self.count += 1 }
    end

    it 'should support single-line expression' do
      expect {
        expect { counter.increment }.to transition { counter.count }
      }.to_not raise_error
    end

    it 'should support multi-line expression' do
      expect {
        expect { counter.increment }.to(
          transition do
            counter.count
          end
        )
      }.to_not raise_error
    end

    it 'should raise on complex expression' do
      expect {
        expect { counter.increment }.to transition { counter.itself.count }
      }.to raise_error TransitionThrough::InvalidExpressionError
    end

    it 'should raise on empty expression' do
      expect {
        expect { counter.increment }.to transition { }
      }.to raise_error TransitionThrough::InvalidExpressionError
    end

    it 'should raise on no expression' do
      expect {
        expect { counter.increment }.to transition
      }.to raise_error TransitionThrough::InvalidExpressionError
    end

    it 'should support arrays' do
      expect { counter.increment(3) }.to transition { counter.count }.through [0, 1, 2, 3]
    end

    it 'should support rest' do
      expect { counter.increment(3) }.to transition { counter.count }.through 0, 1, 2, 3
    end

    it 'should support range' do
      expect { counter.increment(3) }.to transition { counter.count }.through 0..3
    end

    it 'should track transitions' do
      expect {
        counter.count  = 0
        counter.count += 1
        counter.count  = counter.count + 3
        counter.count -= 2
      }.to transition { counter.count }.through [0, 1, 4, 2]
    end
  end

  context 'using ivars' do
    temporary_model :counter, table_name: nil, base_class: nil do
      attr_accessor :count

      def initialize       = @count = 0
      def increment(n = 1) = n.times { @count += 1 }
    end

    # TODO(ezekg) not sure this is possible since you can't redefine an ivar setter
    it 'should not track transitions' do
      expect { counter.increment(3) }.to transition { counter.count }.through [0]
    end
  end
end
