require 'valid_email'

module AML
  class Operator < ApplicationRecord
    extend Enumerize
    include Workflow

    enumerize :workflow_state, in: %w[blocked unblocked], scope: true
    enum role: [:operator, :administrator]

    scope :ordered, -> { order 'id desc' }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy

    validates :password, length: { minimum: 8 }, on: :update, if: :crypted_password_changed?
    validates :password, confirmation: true, on: :update, if: :crypted_password_changed?
    validates :password_confirmation, presence: true, on: :update, if: :crypted_password_changed?
    validates :email, presence: true, uniqueness: true, email: true

    after_commit :deliver_reset_password_instructions!, on: :create

    workflow do
      state :unblocked do
        event :block, transitions_to: :blocked
      end

      state :blocked do
        event :unblock, transitions_to: :unblocked
      end
    end

    def to_partial_path
      'operator'
    end

    def active_for_authentication?
      unblocked?
    end
  end
end
