module Spree
  # This simple event bus is accessible in the code as Spree.event_bus
  # Use this event bus to subscribe different code to run when events happen in
  # Solidus. Reference https://github.com/solidusio/solidus/pull/2431 for some
  # code examples on how to use this.
  #
  # Make sure to call `#subscribe` early enough in your application (in an
  # initializer for example) so that no events are missed. The `#subscribe`
  # method expects to be given an event name (as a symbol), and a Proc (or
  # something that responds to `#call`).
  #
  # There can be more than one subscriber to any event in Solidus. Calling
  # `#subscribe` does not override/clear any existing subscriptions.
  #
  # To override specific subscriptions (like the default customer notifications
  # that Solidus provides) refer to the processor class that has registered
  # those subscriptions (Spree::Events::Processors::MailProcessor for example).
  class EventBus
    include Singleton

    def initialize
      @subscriptions = Hash.new { |hash, key| hash[key] = [] }
    end

    def publish(name, event)
      @subscriptions[name].each do |subscription_proc|
        subscription_proc.call(event)
      end
    end

    def subscribe(name, proc_to_call)
      subscription = @subscriptions[name]
      subscription << proc_to_call unless subscription.include?(proc_to_call)
    end

    def subscriber_count(name)
      @subscriptions[name].size
    end

    def clear_subscribers(name)
      @subscriptions[name].clear
    end
  end
end
