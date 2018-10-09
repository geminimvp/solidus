# frozen_string_literal: true

module Spree
  module Events
    module Processors
      class MailProcessor
        class << self
          def send_confirm_email(event)
            order = Spree::Order.find(event.order_id)
            Spree::Config.order_mailer_class.confirm_email(order).deliver_later unless order.confirmation_delivered?
            order.update_column(:confirmation_delivered, true)
          end

          def send_cancel_email(event)
            order = Spree::Order.find(event.order_id)
            Spree::Config.order_mailer_class.cancel_email(order).deliver_later
          end

          def send_inventory_cancellation_email(event)
            order = Spree::Order.find(event.order_id)
            inventory_units = Spree::InventoryUnit.find(event.inventory_unit_ids)
            Spree::Config.order_mailer_class.inventory_cancellation_email(order, inventory_units).deliver_later
          end

          def send_reimbursement_email(event)
            reimbursement = Spree::Reimbursement.find(event.reimbursement_id)
            Spree::ReimbursementMailer.reimbursement_email(reimbursement).deliver_later
          end

          def send_carton_shipped_emails(event)
            carton = Spree::Carton.find(event.carton_id)
            return if carton.inventory_units.any? { |unit| unit.shipment.suppress_mailer }
            carton.orders.each do |order|
              # .fulfillable? in the case of an item that isn't actually
              # shipped, such as a digital gift card
              Spree::Config.carton_shipped_email_class.shipped_email(order: order, carton: carton).deliver_later if carton.stock_location.fulfillable?
            end
          end
        end
      end
    end
  end
end
