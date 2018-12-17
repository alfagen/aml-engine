class AddNotificationTemplatesToPaymenCardOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_payment_card_orders, :on_pending_notification, foreign_key: {to_table: :aml_notifications}
    add_reference :aml_payment_card_orders, :on_accept_notification, foreign_key: {to_table: :aml_notifications}
    add_reference :aml_payment_card_orders, :on_reject_notification, foreign_key: {to_table: :aml_notifications}
  end
end
