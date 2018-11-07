module AML
  class OrderCheck < ApplicationRecord
    include Workflow

    belongs_to :aml_order, class_name: 'AML::Order'
    belongs_to :aml_check_list, class_name: 'AML::CheckList'

    workflow do
      state :none do
        event :accept, transitions_to: :accepted, if: :aml_order_processing?
        event :reject, transitions_to: :rejected, if: :aml_order_processing?
      end
      state :accepted do
        event :reject, transitions_to: :rejected, if: :aml_order_processing?
      end
      state :rejected do
        event :accept, transitions_to: :accepted, if: :aml_order_processing?
      end
    end

    delegate :processing?, to: :aml_order, prefix: true
  end
end
