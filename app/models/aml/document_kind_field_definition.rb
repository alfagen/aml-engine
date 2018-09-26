module AML
  # TODO Переименовать в FielDefinition
  #
  class DocumentKindFieldDefinition < ApplicationRecord
    include Archivable

    belongs_to :aml_document_kind, class_name: 'AML::DocumentKind',
                                   foreign_key: 'document_kind_id',
                                   inverse_of: :aml_definitions

    # Зачем эта ассоциация тут?
    has_many :aml_document_fields, class_name: 'AML::DocumentField', inverse_of: :aml_definitions

    scope :ordered, -> { order 'position desc' }

    validates :title, presence: true, uniqueness: { scope: :document_kind_id }
    validates :key, presence: true, format: { with: /[a-z_]+/ }, uniqueness: { scope: :archived_at }
  end
end
