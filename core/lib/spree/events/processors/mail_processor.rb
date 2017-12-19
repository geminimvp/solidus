module Spree
  module Events
    module Processors
      class MailProcessor
        class << self
          # This subscribes the MailProcessor to the relevant events in Solidus.
          # It is called in an initializer BEFORE events start happening.
          def register!
            Spree.event_bus.subscribe(:order_confirmed,           ->(event) { send_confirm_email(event) })
            Spree.event_bus.subscribe(:order_cancelled,           ->(event) { send_cancel_email(event) })
            Spree.event_bus.subscribe(:carton_shipped,            ->(event) { send_carton_shipped_emails(event) })
            Spree.event_bus.subscribe(:reimbursement_processed,   ->(event) { send_reimbursement_email(event) })
            Spree.event_bus.subscribe(:order_inventory_cancelled, ->(event) { send_inventory_cancellation_email(event) })
          end

          def send_confirm_email(event)
            Spree::OrderMailer.confirm_email(event.order).deliver_later unless event.order.confirmation_delivered?
            event.order.update_column(:confirmation_delivered, true)
          end

          def send_cancel_email(event)
            Spree::OrderMailer.cancel_email(event.order).deliver_later
          end

          def send_inventory_cancellation_email(event)
            Spree::OrderMailer.inventory_cancellation_email(event.order, event.inventory_units).deliver_later
          end

          def send_reimbursement_email(event)
            Spree::ReimbursementMailer.reimbursement_email(event.reimbursement.id).deliver_later
          end

          def send_carton_shipped_emails(event)
            carton = event.carton
            return if carton.inventory_units.any? { |unit| unit.shipment.suppress_mailer }
            carton.orders.each do |order|
              Spree::Config.carton_shipped_email_class.shipped_email(order: order, carton: carton).deliver_later if carton.stock_location.fulfillable? # e.g. digital gift cards that aren't actually shipped
            end
          end
        end
      end
    end
  end
end
