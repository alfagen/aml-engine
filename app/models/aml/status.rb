module AML
  class Status < ApplicationRecord
    include Archivable
    include Authority::Abilities

    translates :title, :details
    globalize_accessors

    scope :ordered, -> { order :position }

    has_many :aml_document_group_to_statuses, class_name: 'AML::DocumentGroupToStatus', inverse_of: :aml_status, foreign_key: :aml_status_id
    has_many :aml_document_groups, through: :aml_document_group_to_statuses, class_name: 'AML::DocumentGroup'
    has_many :document_kinds, class_name: 'AML::DocumentKind', through: :aml_document_group_to_statuses

    has_many :orders, class_name: 'AML::Order', foreign_key: :aml_status_id
    has_many :clients, class_name: 'AML::Client', foreign_key: :aml_status_id

    belongs_to :on_pending_notification, class_name: 'AML::Notification', optional: true
    belongs_to :on_accept_notification, class_name: 'AML::Notification', optional: true
    belongs_to :on_reject_notification, class_name: 'AML::Notification', optional: true

    register_currency :eur
    monetize :max_amount_limit_cents
    monetize :order_income_limit_amount_cents

    validates :title, presence: true, uniqueness: { case_sensitive: false }
    validates :key, presence: true, uniqueness: { case_sensitive: false }

    before_create do
      self.position = self.class.count + 1
    end

    def next_status
      AML::Status.ordered.where('position > ?', position).first
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
