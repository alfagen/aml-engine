require 'enumerize'

module AML
  class Operator < ApplicationRecord
    extend Enumerize
    include Workflow
    include Authority::Abilities

    scope :ordered, -> { order 'id desc' }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy
    belongs_to :user, optional: true

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
  end
end
