module Spree
  module Events
    class CartonShippedEvent
      attr_reader :carton

      def initialize(carton:)
        @carton = carton
      end
    end
  end
end
