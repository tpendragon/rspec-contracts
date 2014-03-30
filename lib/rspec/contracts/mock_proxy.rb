require "rspec/mocks"
require "rspec/contracts/message"
require "rspec/contracts/returned_response"

module RSpec
  module Contracts
    class MockProxy < Mocks::Proxy
      def initialize(object, order_group, interface)
        super(object, order_group)
        @method_doubles = Hash.new do |h, k|
          h[k] = ContractMethodDouble.new(interface, object, k, self)
        end
      end
    end

    class ContractMethodDouble < Mocks::MethodDouble
      attr_reader :message

      def initialize(interface, object, method_name, proxy)
        @message = Message.new method_name
        interface.add_message @message
        super(object, method_name, proxy)
      end

      def set_arguments(arguments)
        @message.arguments = arguments
      end

      def add_response(response)
        @message.response = response
      end

      def add_simple_stub(method_name, return_value)
        add_response ReturnedResponse.new(return_value)
        super
      end

      def message_expectation_class
        ContractMessageExpectation
      end
    end

    class ContractMessageExpectation < Mocks::MessageExpectation
      def with(*args)
        @method_double.set_arguments args
        super
      end

      def and_return(*args)
        @method_double.add_response ReturnedResponse.new(args.first)
        super
      end
    end
  end
end
