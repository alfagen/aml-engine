module AML
  class DocumentGroupToStatus < ApplicationRecord
    belongs_to :aml_document_group, class_name: 'AML::DocumentGroup'
    belongs_to :aml_status, class_name: 'AML::Status'
    has_many :document_kinds, through: :aml_document_group, class_name: 'AML::DocumentKind'
  end
end
