module Spree
  module Events
    class OrderInventoryCancelledEvent
      attr_reader :order, :inventory_units

      def initialize(order:, inventory_units:)
        @order = order
        @inventory_units = inventory_units
      end
    end
  end
end
