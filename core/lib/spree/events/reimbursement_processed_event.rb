module Spree
  module Events
    class ReimbursementProcessedEvent
      attr_reader :reimbursement

      def initialize(reimbursement:)
        @reimbursement = reimbursement
      end
    end
  end
end
