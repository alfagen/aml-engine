require 'valid_email'
require 'enumerize'

module AML
  class Operator < ApplicationRecord
    extend Enumerize
    include Workflow

    enumerize :workflow_state, in: %w[blocked unblocked], scope: true
    enum role: [:operator, :administrator]

    scope :ordered, -> { order 'id desc' }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy
    has_one :user, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    workflow do
      state :unblocked do
        event :block, transitions_to: :blocked
      end

      state :blocked do
        event :unblock, transitions_to: :unblocked
      end
    end

    def to_s
      "[#{id}] #{name}"
    end

    def to_partial_path
      'operator'
    end

    def time_zone_object
      return unless time_zone.present?
      ActiveSupport::TimeZone[time_zone]
    end
  end
end
