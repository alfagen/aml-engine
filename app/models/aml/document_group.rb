module AML
  class DocumentGroup < ApplicationRecord
    include Archivable
    include Authority::Abilities

    translates :title, :details
    globalize_accessors

    has_many :aml_document_group_to_statuses, class_name: 'AML::DocumentGroupToStatus',
      inverse_of: :aml_document_group, foreign_key: :aml_document_group_id
    has_many :aml_statuses, through: :aml_document_group_to_statuses, class_name: 'AML::Status'
    has_many :document_kinds, class_name: 'AML::DocumentKind', dependent: :destroy, foreign_key: :aml_document_group_id

    scope :ordered, -> { order :position }

    validates :title, presence: true, uniqueness: true

    before_create do
      if self.class.any?
        self.position ||= self.class.last.position + 1
      else
        self.position = 1
      end
    end
  end
end
