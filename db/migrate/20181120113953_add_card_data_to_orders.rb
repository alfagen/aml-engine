class AddCardDataToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :card_brand, :string
    add_column :aml_orders, :card_bin, :string, length: 4
    add_column :aml_orders, :card_suffix, :string, length: 4
    add_column :aml_orders, :card_holded, :boolean, null: false, default: false
    add_column :aml_orders, :card_holded_at, :timestamp
  end
end
