module AML
  # TODO Переименовать в DocumentField
  class DocumentField < ApplicationRecord
    ClosedOrderError = Class.new StandardError

    scope :ordered, -> { order 'id desc' }

    belongs_to :order_document, class_name: 'AML::OrderDocument',
                                 foreign_key: 'order_document_id',
                                 inverse_of: :document_fields

    belongs_to :definition, class_name: 'AML::DocumentKindFieldDefinition',
                            foreign_key: :document_kind_field_definition_id,
                            inverse_of: :document_fields

    validates :document_kind_field_definition_id, uniqueness: { scope: :order_document_id }

    before_validation :validate_order_open!

    alias_attribute :definition_id, :document_kind_field_definition_id

    delegate :title, :key, to: :definition

    def validate_order_open!
      raise ClosedOrderError if order_document.order.is_locked? && value_changed?
    end
  end
end
