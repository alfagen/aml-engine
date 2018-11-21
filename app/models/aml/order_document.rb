# frozen_string_literal: true

module AML
  class OrderDocument < ApplicationRecord
    include Authority::Abilities

    # 'Can`t update document of locker order'
    class ClosedOrderError < StandardError
      def message
        'Нельзя редактировать документ. Заявка закрыта для изменений.'
      end
    end

    extend Enumerize
    include Workflow

    mount_uploader :image, OrderDocumentFileUploader

    belongs_to :order, class_name: 'AML::Order', foreign_key: 'order_id', inverse_of: :order_documents
    belongs_to :document_kind, class_name: 'AML::DocumentKind', foreign_key: 'document_kind_id', inverse_of: :order_documents
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', optional: true

    # TODO переиименовать в document_fields
    has_many :document_fields, class_name: 'AML::DocumentField', dependent: :destroy
    has_many :definitions, through: :document_kind, source: :definitions

    scope :ordered, -> { order 'id desc' }
    scope :loaded_and_available, -> { where.not(workflow_state: 'rejected').where.not(image: nil) }

    # TODO недавать загружать в обрабатываемую или обработанную заявку
    # validates :image, presence: true
    # validates :document_kind_id, uniqueness: { scope: :order_id }

    # none - Документ ожидает загрузки (draft)
    # loaded - Документ загружен
    # processing - Проверка документа
    # accepted - Документ одобрен
    # rejected - Отклонен (причина reason)
    #

    workflow do
      # Переименовать none в draft
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

    accepts_nested_attributes_for :document_fields, update_only: true

    def reject(reject_reason:, details: nil)
      halt! 'Причина должна быть указана' unless reject_reason.is_a? AML::RejectReason
      update aml_reject_reason: reject_reason, reject_reason_details: details
    end

    def document_fields_attributes
      document_fields.map do |document_field|
        document_field.as_json only: %i[value document_kind_field_definition_id]
      end
    end

    def fields(reload = false)
      @fields = nil if reload
      @fields ||= document_fields.each_with_object({}) do |document_field, agg|
        agg[document_field.key] = document_field.value
      end.freeze
    end

    def fields=(new_fields = {})
      validate_order_open!
      @fields = new_fields
    end

    private

    def validate_order_open!
      raise ClosedOrderError if order.is_locked? && image_changed?
    end

    def create_fields!
      definitions.alive.pluck(:id).each do |definition_id|
        document_fields.create! definition_id: definition_id, order_document: self
      end
    end

    def save_fields!
      return if @fields.nil?

      updated_ids = document_fields.each do |cdf|
        cdf.update value: fields[cdf.key]
        cdf.id
      end

      document_fields.where.not(id: updated_ids).update_all value: nil
    end
  end
end
