module AML
  class DocumentGroup < ApplicationRecord
    include Archivable

    has_many :aml_document_group_to_statuses, class_name: 'AML::DocumentGroupToStatus', inverse_of: :aml_document_group
    has_many :aml_statuses, through: :aml_document_group_to_statuses, class_name: 'AML::Status'
    has_many :aml_document_kinds, class_name: 'AML::DocumentKind', dependent: :destroy, inverse_of: :aml_document_group

    scope :ordered, -> { order :position }

    validates :title, presence: true, uniqueness: true
  end
end
