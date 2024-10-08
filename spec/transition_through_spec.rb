# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TransitionThrough do
  let(:counter) { Counter.new }

  context 'using ivars' do
    temporary_model :counter, table_name: nil, base_class: nil do
      attr_accessor :count

      def initialize              = @count = 0
      def increment(n = 1, by: 1) = n.times { @count += by }
      def decrement(n = 1, by: 1) = n.times { @count -= by }
    end

    # TODO(ezekg) not sure this is possible since you can't observe an ivar
    it 'should not track transitions' do
      expect { counter.increment(3) }.to transition { counter.count }.nowhere
    end
  end

  context 'using methods' do
    temporary_model :counter, table_name: nil, base_class: nil do
      attr_accessor :count

      def initialize              = self.count = 0
      def increment(n = 1, by: 1) = n.times { self.count += by }
      def decrement(n = 1, by: 1) = n.times { self.count += by }
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

    it 'should support nothing' do
      expect { }.to transition { counter.count }
    end

    it 'should support nowhere' do
      expect { }.to transition { counter.count }.nowhere
    end

    it 'should track transitions' do
      expect {
        counter.count  = 0
        counter.count += 1
        counter.count  = counter.count + 3
        counter.count -= 2
      }.to transition { counter.count }.through [0, 1, 4, 2]
    end

    describe 'README' do
      it 'should transition through' do
        counter = Counter.new
        count   = -> {
          counter.count = 0
          counter.increment
          counter.count  = counter.count + 3
          counter.count -= 2
          counter.decrement(by: 2)
        }

        expect { count.call }.to transition { counter.count }.through [0, 1, 4, 2, 0]
      end

      it 'should transition nowhere' do
        counter = Counter.new
        count   = -> {}

        expect { count.call }.to transition { counter.count }.nowhere
      end
    end
  end
end
