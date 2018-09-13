# This migration comes from aml (originally 20180911080249)
class AddRejectReasonToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :reject_reason, :text
  end
end
