module AML
  class DocumentKindFieldDefinition < ApplicationRecord
    include Authority::Abilities
    include Archivable

    self.table_name = 'aml_document_kind_field_definitions'

    belongs_to :document_kind, class_name: 'AML::DocumentKind',
                               foreign_key: 'document_kind_id',
                               inverse_of: :definitions

    has_many :client_document_fields, dependent: :destroy

    scope :ordered, -> { order 'id desc' }

    validates :title, presence: true
    validates :key, presence: true, format: { with: /[a-z_]+/ }, uniqueness: { scope: :document_kind }
  end
end
