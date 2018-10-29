module AML
  class LimitsChecker
    class Error < StandardError
      def initialize(message = nil, recomended_status: nil)
        @recomended_status = recomended_status
      end
    end

    NoClient                  = Class.new Error
    LimitsReached             = Class.new Error
    NoStatus                  = Class.new Error
    MaxAmountReached          = Class.new LimitsReached
    MaxOperationsCountReached = Class.new LimitsReached
    NoReferalsAllowed         = Class.new Error

    def initialize(aml_client: )
      @aml_client = aml_client
    end

    def check_common_operation!(income_amount: )
      check!
      raise MaxAmountReached, next_status if income_amount >= current_status.max_amount_limit

      raise MaxOperationsCountReached, next_status if aml_client.total_operations_count >= current_status.operations_count_limit

      true
    end

    def check_referal_operation!
      check!
      raise NoReferalsAllowed unless current_status.referal_output_enabled?

      true
    end

    private

    attr_reader :aml_client

    delegate :next_status, to: :current_status

    def current_status
      aml_client.aml_status
    end

    def check!
      raise NoClient if aml_client.nil?
      raise NoStatus, AML.default_status if current_status.nil?
      raise 'Must be an AML::Client' unless aml_client.is_a? AML::Client
    end
  end
end
