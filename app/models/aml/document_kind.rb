# frozen_string_literal: true

module AML
  class DocumentKind < ApplicationRecord
    include Authority::Abilities

    self.table_name = 'aml_document_kinds'

    scope :ordered, -> { order 'id desc' }

    has_many :client_documents, class_name: 'AML::ClientDocument', dependent: :destroy
    has_many :document_kind_field_definitions, class_name: 'AML::DocumentKindFieldDefinition', dependent: :destroy

    validates :title, presence: true, uniqueness: true
  end
end
