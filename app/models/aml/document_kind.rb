# frozen_string_literal: true

module AML
  class DocumentKind < ApplicationRecord
    include Authority::Abilities
    include Archivable::Model

    scope :ordered, -> { order 'id desc' }

    has_many :order_documents, class_name: 'AML::OrderDocument', dependent: :destroy
    has_many :definitions, class_name: 'AML::DocumentKindFieldDefinition', dependent: :destroy

    validates :title, presence: true, uniqueness: true

    # TODO в отдельную колонку
    def position
      id
    end
  end
end
