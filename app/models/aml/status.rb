module AML
  class Status < ApplicationRecord
    include Archivable

    translates :title, :details
    globalize_accessors

    scope :ordered, -> { order :position }

    has_many :aml_document_group_to_statuses, class_name: 'AML::DocumentGroupToStatus', inverse_of: :aml_status, foreign_key: :aml_status_id
    has_many :aml_document_groups, through: :aml_document_group_to_statuses, class_name: 'AML::DocumentGroup'
    has_many :document_kinds, class_name: 'AML::DocumentKind', through: :aml_document_group_to_statuses

    has_many :orders, class_name: 'AML::Order', foreign_key: :aml_status_id
    has_many :clients, class_name: 'AML::Client', foreign_key: :aml_status_id

    register_currency :eur
    monetize :max_amount_limit_cents

    validates :title, presence: true, uniqueness: true
    validates :key, presence: true, uniqueness: true

    before_create do
      self.position = self.class.count + 1
    end

    def default?
      key == AML.default_status_key
    end

    def to_s
      "#{title} (#{position})"
    end

    def not_belong_groups
      DocumentGroup.where.not(id: aml_document_groups.pluck(:aml_document_group_id))
    end
  end
end
