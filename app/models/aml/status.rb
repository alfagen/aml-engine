module AML
  class Status < ApplicationRecord
    include Archivable

    scope :ordered, -> { order :position }

    has_many :aml_document_group_to_statuses, class_name: 'AML::DocumentGroupToStatus', inverse_of: :aml_status, foreign_key: :aml_status_id
    has_many :aml_document_groups, through: :aml_document_group_to_statuses, class_name: 'AML::DocumentGroup'
    has_many :document_kinds, class_name: 'AML::DocumentKind', through: :aml_document_group_to_statuses

    validates :title, presence: true, uniqueness: true
    validates :key, presence: true, uniqueness: true

    before_create do
      self.position = AML::Status.count + 1
    end
  end
end
