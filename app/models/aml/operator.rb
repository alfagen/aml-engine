require 'valid_email'
require 'enumerize'

module AML
  class Operator < ApplicationRecord
    extend Enumerize
    include Workflow

    scope :ordered, -> { order 'id desc' }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy
    has_one :user, class_name: 'User', foreign_key: :aml_operator_id, inverse_of: :aml_operator, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    enum role: [:operator, :administrator]

    enumerize :workflow_state, in: %w[blocked unblocked], scope: true

    workflow do
      state :unblocked do
        event :block, transitions_to: :blocked
      end

      state :blocked do
        event :unblock, transitions_to: :unblocked
      end
    end

    # Удаляем методы определнные в workflow, чтобы они не конфликтовали
    # с authority
    remove_method :can_block?, :can_unblock?

    def to_s
      "[#{id}] #{name}"
    end

    def to_partial_path
      'operator'
    end

    def time_zone
      return unless time_zone_name.present?
      ActiveSupport::TimeZone[time_zone_name]
    end
  end
end
