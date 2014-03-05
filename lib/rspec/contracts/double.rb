require "rspec/mocks"
require "rspec/contracts/mock_proxy"

module RSpec
  module Contracts
    class Double
      include Mocks::TestDouble

      def initialize(interface_name, *args)
        @interface_name = interface_name
        __initialize_as_test_double interface_name, *args
      end

      def __build_mock_proxy(order_group)
        MockProxy.new self, order_group, @interface_name
      end
    end
  end
end
