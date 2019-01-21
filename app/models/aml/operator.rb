require 'valid_email'
require 'enumerize'

module AML
  class Operator < ApplicationRecord
    extend Enumerize
    include Workflow
    include Authority::Abilities

    scope :ordered, -> { order 'id desc' }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy
    has_many :payment_card_orders, class_name: 'AML::PaymentCardOrder', dependent: :destroy

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

    def notify(template_id, data = {})
      unless enable_notification
        AML::NotificationMailer.logger.warn "У оператора #{id} увеломдения запрещены"
        return
      end
      unless email.present?
        AML::NotificationMailer.logger.error "У оператора #{id} нет email-а"
        return
      end
      AML::NotificationMailer.
        notify( email: email, template_id: template_id, data: data).
        deliver!
    end

    def to_s
      "[#{id}] #{name}"
    end

    def to_partial_path
      'operator'
    end
  end
end
