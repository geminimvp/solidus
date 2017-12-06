module Spree
  module Events
    class ReimbursementFailedEvent
      attr_reader :reimbursement

      def initialize(reimbursement:)
        @reimbursement = reimbursement
      end
    end
  end
end
