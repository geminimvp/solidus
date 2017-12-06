module Spree
  module Events
    class OrderConfirmedEvent
      attr_reader :order

      def initialize(order:)
        @order = order
      end
    end
  end
end
