module AML
  class OrderCheck < ApplicationRecord
    include Workflow

    belongs_to :aml_order
    belongs_to :aml_check_list

    workflow do
      state :none do
        event :accept, transitions_to: :accepted, if: :order_processing?
        event :reject, transitions_to: :rejected, if: :order_processing?
      end
      state :accepted
      state :rejected
    end

    delegate :processing?, to: :order, prefix: true
  end
end
