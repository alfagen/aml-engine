require 'valid_email'

module AML
  class Operator < ApplicationRecord
    include WorkflowActiverecord
    include Authority::Abilities

    scope :ordered, -> { order 'id desc' }

    scope :with_unblocked_state, -> { where workflow_state: :unblocked }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy
    has_many :payment_card_orders, class_name: 'AML::PaymentCardOrder', dependent: :destroy

    enum :role, [:operator, :administrator]

    enum :workflow_state, { blocked: 'blocked', unblocked: 'unblocked' }

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
        AML::NotificationMailer.logger.debug "У оператора #{id} увеломдения запрещены, выходим из AML::Operator#notify"
        return
      end
      unless email.present?
        AML::NotificationMailer.logger.error "У оператора #{id} нет email-а"
        return
      end
      AML::NotificationMailer.notify( email, template_id, data).deliver!
    end

    def to_s
      "[#{id}] #{name}"
    end

    def to_partial_path
      'operator'
    end
  end
end
