# frozen_string_literal: true

module AML
  # TODO: rename в OrderDocument
  class ClientDocument < ApplicationRecord
    extend Enumerize
    include Workflow
    include Authority::Abilities

    mount_uploader :image, FileUploader

    belongs_to :order, class_name: 'AML::Order', foreign_key: 'order_id', inverse_of: :order_documents
    belongs_to :document_kind, class_name: 'AML::DocumentKind', foreign_key: 'document_kind_id', inverse_of: :order_documents

    has_many :client_document_fields, class_name: 'AML::ClientDocumentField', dependent: :destroy
    has_many :document_kind_field_definitions, through: :document_kind, source: :definitions

    scope :ordered, -> { order 'id desc' }

    # validates :image, presence: true
    validates :document_kind_id, uniqueness: { scope: :order_id }

    enumerize :workflow_state, in: %w[pending accepted rejected], scope: true

    accepts_nested_attributes_for :client_document_fields, update_only: true

    workflow do
      state :pending do
        event :accept, transitions_to: :accepted
        event :reject, transitions_to: :rejected
      end

      state :accepted do
        event :reject, transitions_to: :rejected
      end

      state :rejected do
        event :accept, transitions_to: :accepted
      end
    end

    after_create :create_fields!

    def client_document_fields_attributes
      client_document_fields.map do |document_field|
        document_field.as_json only: %i[value document_kind_field_definition_id]
      end
    end

    def fields(reload = false)
      @fields = nil if reload
      @fields ||= client_document_fields.each_with_object({}) do |document_field, agg|
        agg[document_field.key] = document_field.value
      end.freeze
    end

    def fields=(_value)
      self.client_document_fields_attributes = fields.map do |_k, v|
        {
          definition: document_kind_field_definitions.find_by(key: key),
          client_document_id: id,
          value: v
        }
      end
    end

    private

    # TODO: устанавливать когда хоть что-нибудь появится, а может лучше вообще из API
    def order_loading
      order.load! if order.none? && order.complete?
    end

    def create_fields!
      document_kind_field_definitions.alive.pluck(:id).each do |definition_id|
        client_document_fields.create! definition_id: definition_id, client_document: self
      end
    end
  end
end
