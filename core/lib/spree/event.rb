# frozen_string_literal: true

require_relative 'event/adapters/active_support_notifications'

module Spree
  module Event
    POSTFIX = '.spree'

    extend self

    # Allows to trigger events that can be subscribed using #subscribe. An
    # optional block can be passed that will be executed immediately. The
    # actual code implementation is delegated to the adapter.
    #
    # @param [String] event_name the name of the event. The postfix ".spree"
    #  will be added automatically if not present
    # @param [Hash] opts a list of options to be passed to the triggered event
    #
    # @example Trigger an event named 'order_finalize'
    #   Spree::Event.instrument 'order_finalize', order: @order do
    #     @order.finalize!
    #   end
    def instrument(event_name, opts = {})
      adapter.instrument name_with_postfix(event_name), opts do
        yield opts if block_given?
      end
    end

    # Subscribe to an event with the given name. The provided block is executed
    # every time the subscribed event is fired.
    #
    # @param [String] event_name the name of the event. The postfix ".spree"
    #  will be added automatically if not present
    #
    # @return a subscription object that can be used as reference in order
    #  to remove the subscription
    #
    # @example Subscribe to the `order_finalize` event
    #   Spree::Event.subscribe 'order_finalize' do |event|
    #     order = event.payload[:order]
    #     Spree::Mailer.order_finalized(order).deliver_later
    #   end
    #
    # @see Spree::Event#unsubscribe
    def subscribe(event_name, &block)
      name = name_with_postfix(event_name)
      listener_names << name
      adapter.subscribe(name, &block)
    end

    # Unsubscribes a whole event or a specific subscription object
    #
    # @param [String, Object] subscriber the event name as a string (with
    #  or without the ".spree" postfix) or the subscription object
    #
    # @example Unsubscribe a single subscription
    #   subscription = Spree::Event.instrument 'order_finalize'
    #   Spree::Event.unsubscribe(subscription)
    # @example Unsubscribe all `order_finalize` event subscriptions
    #   Spree::Event.unsubscribe('order_finalize')
    # @example Unsubscribe an event by name with explicit prefix
    #   Spree::Event.unsubscribe('order_finalize.spree')
    def unsubscribe(subscriber)
      name_or_subscriber = subscriber.is_a?(String) ? name_with_postfix(subscriber) : subscriber
      adapter.unsubscribe(name_or_subscriber)
    end

    # Lists all subscriptions currently registered under the ".spree"
    # namespace. Actual implementation is delegated to the adapter
    #
    # @return [Hash] an hash with event names as keys and arrays of subscriptions
    #  as values
    #
    # @example Current subscriptions
    #  Spree::Event.listeners
    #    # => {"order_finalize.spree"=> [#<ActiveSupport...>],
    #      "reimbursement_perform.spree"=> [#<ActiveSupport...>]}
    def listeners
      adapter.listeners_for(listener_names)
    end

<<<<<<< HEAD
<<<<<<< HEAD
=======
    # The adapter used by Spree::Event, defaults to
    # Spree::Event::Adapters::ActiveSupportNotifications
    #
    # @example Change the adapter
    #   Spree::Config.event_adapter_class_name = "Spree::EventBus"
    #
    # @see Spree::AppConfiguration
=======
>>>>>>> de6467668... `Spree::Event.adapter` is now a preference from `Spree::Config`
    def adapter
      @adapter ||= Spree::Config.event_adapter_class_name.constantize
    end

<<<<<<< HEAD
>>>>>>> 704ac9445... Add documentation in Yard format to `Spree::Event`
=======
>>>>>>> de6467668... `Spree::Event.adapter` is now a preference from `Spree::Config`
    private

    def name_with_postfix(name)
      name.end_with?(POSTFIX) ? name : [name, POSTFIX].join
    end

    def listener_names
      @listeners_names ||= Set.new
    end
  end
end
