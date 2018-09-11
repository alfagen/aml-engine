class AddRejectReasonToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :reject_reason, :text
  end
end
