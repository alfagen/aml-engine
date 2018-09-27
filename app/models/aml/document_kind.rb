# frozen_string_literal: true

module AML
  class DocumentKind < ApplicationRecord
    include Archivable

    scope :ordered, -> { order 'position desc' }

    belongs_to :document_group, class_name: 'AML::DocumentGroup', foreign_key: :aml_document_group_id, inverse_of: :document_kinds
    has_many :definitions, class_name: 'AML::DocumentKindFieldDefinition', dependent: :destroy
    has_many :order_documents, class_name: 'AML::OrderDocument', dependent: :destroy

    validates :title, presence: true, uniqueness: true

    # Поддержка для Serializer
    alias_attribute :document_group_id, :aml_document_group_id
  end
end
