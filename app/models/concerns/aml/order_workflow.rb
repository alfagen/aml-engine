module AML
  module OrderWorkflow
    extend ActiveSupport::Concern

    included do
      workflow_column :workflow_state

      workflow do
        state :none do
          event :done, transitions_to: :pending, if: :allow_done?
          event :cancel, transitions_to: :canceled
        end

        # Пользователь загрузил, ждет когда оператор начнет обрабатывать
        state :pending do
          on_entry do
            notify :on_pending_notification
          end
          event :start, transitions_to: :processing
          event :cancel, transitions_to: :canceled
        end

         # Оператор начал обрабатывать
        state :processing do
          event :accept, transitions_to: :accepted, if: :allow_accept?
          event :reject, transitions_to: :rejected
          event :cancel, transitions_to: :pending
        end

        state :accepted do
          # TODO сомнительно что можно так делать
          event :reject, transitions_to: :rejected
          on_entry do
            notify :on_accept_notification
          end
        end

        # Отклонена оператором
        state :rejected do
          on_entry do
            notify :on_reject_notification
          end
        end

        # Отменена пользователем (или автоматом при создании новой)
        state :canceled
      end
    end

    def start(operator:)
      update operator: operator
    end

    def cancel
      update operator: nil
      touch :operated_at
    end

    def reject(reject_reason:, details: nil)
      halt! 'Причина должна быть указана' unless reject_reason.is_a? AML::RejectReason
      update aml_reject_reason: reject_reason, reject_reason_details: details
      touch :operated_at
    end
  end
end
