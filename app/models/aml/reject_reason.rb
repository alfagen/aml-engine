module AML
  class RejectReason < ApplicationRecord
    include Archivable
    include Authority::Abilities

    translates :title
    globalize_accessors

    scope :ordered, -> { order :id }

    has_many :orders, foreign_key: :aml_reject_reason_id
    has_many :order_documents, foreign_key: :aml_reject_reason_id

    validates :title, presence: true, uniqueness: true

    validates :kind, presence: true

    enum kind: ['order_reason', 'order_document_reason']
  end
end
