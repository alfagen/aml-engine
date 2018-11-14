class AddPendingIndexToOrders < ActiveRecord::Migration[5.2]
  def change
    add_index :aml_orders, [:workflow_state, :pending_at]
  end
end
