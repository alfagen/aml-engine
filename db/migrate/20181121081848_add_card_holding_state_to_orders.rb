class AddCardHoldingStateToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :card_holding_state, :string, default: 'none', null: false
    remove_column :aml_orders, :card_holded

    remove_column :aml_orders, :card_holded_at
    add_column :aml_orders, :card_holding_state_updated_at, :timestamp
  end
end
