module AML
  class DocumentKindFieldDefinition < ApplicationRecord
    include Authority::Abilities
    include Archivable::Model

    belongs_to :document_kind, class_name: 'AML::DocumentKind',
                               foreign_key: 'document_kind_id',
                               inverse_of: :definitions

    has_many :client_document_fields, dependent: :destroy

    scope :ordered, -> { order 'id desc' }

    validates :title, presence: true

    validates :key, presence: true, format: { with: /[a-z_]+/ }, uniqueness: { scope: :document_kind_id }

    # Ключ уникальный для всех живых дефиниций
    validates :key, uniqueness: { scope: :archived_at }

    # TODO в отдельную колонку
    def position
      id
    end
  end
end
