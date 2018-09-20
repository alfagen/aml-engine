module AML
  class Status < ApplicationRecord
    include Archivable

    scope :ordered, -> { order :position }

    has_many :aml_document_group_to_statuses, class_name: 'AML::DocumentGroupToStatus', inverse_of: :aml_status, foreign_key: :aml_status_id
    has_many :aml_document_groups, through: :aml_document_group_to_statuses, class_name: 'AML::DocumentGroup'

    validates :title, presence: true, uniqueness: true
  end
end
