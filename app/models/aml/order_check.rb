module AML
  class OrderCheck < ApplicationRecord
    include Workflow

    belongs_to :aml_order
    belongs_to :aml_check_list

    workflow do
      state :none do
        event :accept, transitions_to: :accepted, if: :aml_order_processing?
        event :reject, transitions_to: :rejected, if: :aml_order_processing?
      end
      state :accepted
      state :rejected
    end

    delegate :processing?, to: :aml_order, prefix: true
  end
end
