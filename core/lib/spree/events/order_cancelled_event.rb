module Spree
  module Events
    class OrderCancelledEvent
      attr_reader :order

      def initialize(order:)
        @order = order
      end
    end
  end
end
