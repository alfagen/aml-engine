# frozen_string_literal: true

module AML
  class DocumentKind < ApplicationRecord
    include Authority::Abilities
    include Archivable

    scope :ordered, -> { order 'position desc' }

    has_many :order_documents, class_name: 'AML::OrderDocument', dependent: :destroy
    has_many :definitions, class_name: 'AML::DocumentKindFieldDefinition', dependent: :destroy

    validates :title, presence: true, uniqueness: true
  end
end
