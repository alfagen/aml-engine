class AddOperatedAtToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :operated_at, :timestamp

    execute "update aml_orders set operated_at=updated_at where workflow_state='canceled'"
    execute "update aml_orders set operated_at=updated_at where workflow_state='rejected'"
    execute "update aml_orders set operated_at=updated_at where workflow_state='accepted'"

    add_index :aml_orders, [:workflow_state, :operated_at]
  end
end
