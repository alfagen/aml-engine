module AML
  class DocumentKindFieldDefinition < ApplicationRecord
    include Authority::Abilities
    include Archivable

    self.table_name = 'aml_document_kind_field_definitions'

    scope :ordered, -> { order 'id desc' }

    belongs_to :document_kind, class_name: 'AML::DocumentKind', foreign_key: 'document_kind_id',
                               inverse_of: :document_kind_field_definitions
    has_many :client_document_fields, class_name: 'AML::ClientDocumentField', dependent: :destroy

    validates :title, presence: true
    validates :key, presence: true, format: { with: /[a-z_]+/ }, uniqueness: { scope: :document_kind }
  end
end
