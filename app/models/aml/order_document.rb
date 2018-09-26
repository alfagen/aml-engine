# frozen_string_literal: true

module AML
  class OrderDocument < ApplicationRecord
    # 'Can`t update document of locker order'
    ClosedOrderError = Class.new StandardError

    extend Enumerize
    include Workflow

    mount_uploader :image, FileUploader

    belongs_to :aml_order, class_name: 'AML::Order', foreign_key: 'order_id', inverse_of: :aml_order_documents
    belongs_to :aml_document_kind, class_name: 'AML::DocumentKind', foreign_key: 'document_kind_id', inverse_of: :aml_order_documents

    # TODO переиименовать в document_fields
    has_many :aml_document_fields, class_name: 'AML::DocumentField', dependent: :destroy
    has_many :aml_definitions, through: :aml_document_kind, source: :aml_definitions

    scope :ordered, -> { order 'id desc' }

    alias_attribute :aml_order_id, :order_id
    alias_attribute :aml_document_kind_id, :document_kind_id

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
        event :load, transitions_to: :loaded
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

    accepts_nested_attributes_for :aml_document_fields, update_only: true

    def document_fields_attributes
      aml_document_fields.map do |aml_document_field|
        aml_document_field.as_json only: %i[value document_kind_field_definition_id]
      end
    end

    def fields(reload = false)
      @fields = nil if reload
      @fields ||= aml_document_fields.each_with_object({}) do |aml_document_field, agg|
        agg[aml_document_field.key] = aml_document_field.value
      end.freeze
    end

    def fields=(new_fields = {})
      validate_order_open!
      @fields = new_fields
    end

    private

    def validate_order_open!
      raise ClosedOrderError if aml_order.is_locked?
    end

    def create_fields!
      aml_definitions.alive.pluck(:id).each do |aml_definition_id|
        aml_document_fields.create! document_kind_field_definition_id: aml_definition_id, aml_order_document: self
      end
    end

    def save_fields!
      return if @fields.nil?

      updated_ids = aml_document_fields.each do |cdf|
        cdf.update value: fields[cdf.key]
        cdf.id
      end

      aml_document_fields.where.not(id: updated_ids).update_all value: nil
    end
  end
end
