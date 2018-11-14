class AddPendingToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :pending_at, :timestamp

    execute "update aml_orders set pending_at = created_at where workflow_state='pending'"
    execute "update aml_orders set pending_at = updated_at where workflow_state='done'"
    execute "update aml_orders set pending_at = created_at where workflow_state='accepted'"
  end
end
