class AddReferenceToPaymentCardOrderOnOperator < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_payment_card_orders, :aml_operator, index: true
    add_column :aml_payment_card_orders, :pending_at, :timestamp
    add_column :aml_payment_card_orders, :operated_at, :timestamp

    execute "update aml_payment_card_orders set pending_at = created_at where workflow_state='pending'"
    execute "update aml_payment_card_orders set pending_at = updated_at where workflow_state='done'"
    execute "update aml_payment_card_orders set pending_at = created_at where workflow_state='accepted'"

    execute "update aml_payment_card_orders set operated_at=updated_at where workflow_state='canceled'"
    execute "update aml_payment_card_orders set operated_at=updated_at where workflow_state='rejected'"
    execute "update aml_payment_card_orders set operated_at=updated_at where workflow_state='accepted'"

    add_index :aml_payment_card_orders, [:workflow_state, :operated_at]
    add_index :aml_payment_card_orders, [:workflow_state, :pending_at]
  end
end
