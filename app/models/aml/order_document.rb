# frozen_string_literal: true

module AML
  class OrderDocument < ApplicationRecord
    # 'Can`t update document of locker order'
    ClosedOrderError = Class.new StandardError

    extend Enumerize
    include Authority::Abilities
    include Workflow

    mount_uploader :image, FileUploader

    belongs_to :order, class_name: 'AML::Order', foreign_key: 'order_id', inverse_of: :order_documents
    belongs_to :document_kind, class_name: 'AML::DocumentKind', foreign_key: 'document_kind_id', inverse_of: :order_documents

    # TODO переиименовать в document_fields
    has_many :client_document_fields, class_name: 'AML::ClientDocumentField', dependent: :destroy
    has_many :definitions, through: :document_kind, source: :definitions

    scope :ordered, -> { order 'id desc' }

    # TODO недавать загружать в обрабатываемую или обработанную заявку
    # validates :image, presence: true
    # validates :document_kind_id, uniqueness: { scope: :order_id }

    # none - Документ ожидает загрузки
    # loaded - Документ загружен
    # processing - Проверка документа
    # accepted - Документ одобрен
    # rejected - Отклонен (причина reason)
    #

    workflow do
      state :none do
        event :load, transitions_to: :loaded
      end
      state :loaded do
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

    before_validation :validate_order_open!

    after_create :create_fields!
    before_save :save_fields!

    accepts_nested_attributes_for :client_document_fields, update_only: true

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

    def fields=(new_fields = {})
      validate_order_open!
      @fields = new_fields
    end

    private

    def validate_order_open!
      raise ClosedOrderError if order.is_locked?
    end

    # TODO: устанавливать когда хоть что-нибудь появится, а может лучше вообще из API
    def order_loading
      order.load! if order.none? && order.complete?
    end

    def create_fields!
      definitions.alive.pluck(:id).each do |definition_id|
        client_document_fields.create! definition_id: definition_id, order_document: self
      end
    end

    def save_fields!
      return if @fields.nil?

      updated_ids = client_document_fields.each do |cdf|
        cdf.update value: fields[cdf.key]
        cdf.id
      end

      client_document_fields.where.not(id: updated_ids).update_all value: nil
    end
  end
end
