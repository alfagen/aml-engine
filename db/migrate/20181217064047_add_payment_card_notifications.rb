class AddPaymentCardNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_statuses, :on_card_pending_notification, foreign_key: {to_table: :aml_notifications}
    add_reference :aml_statuses, :on_card_accept_notification, foreign_key: {to_table: :aml_notifications}
    add_reference :aml_statuses, :on_card_reject_notification, foreign_key: {to_table: :aml_notifications}
  end
end
