module AML
  # TODO Переименовать в FielDefinition
  #
  class DocumentKindFieldDefinition < ApplicationRecord
    include Archivable

    belongs_to :document_kind, class_name: 'AML::DocumentKind',
                               foreign_key: 'document_kind_id',
                               inverse_of: :definitions

    # Зачем эта ассоциация тут?
    has_many :client_document_fields, dependent: :destroy

    scope :ordered, -> { order 'position desc' }

    validates :title, presence: true, uniqueness: { scope: :document_kind_id }
    validates :key, presence: true, format: { with: /[a-z_]+/ }, uniqueness: { scope: :archived_at }
  end
end
