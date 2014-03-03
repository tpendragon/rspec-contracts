require "rspec/contracts/requirement_view"

module RSpec
  module Contracts
    class Requirement
      attr_reader :contract_name, :method_name, :arguments, :return_value

      def initialize(contract_name, method_name, options = {})
        @contract_name = contract_name
        @method_name = method_name
        @arguments = options[:arguments]
        @return_value = options[:return_value]
      end

      def self.create(*args)
        requirement = new(*args)
        puts RequirementView.new(requirement).render
      end
    end
  end
end
