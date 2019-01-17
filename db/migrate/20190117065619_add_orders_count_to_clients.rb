class AddOrdersCountToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_clients, :orders_count, :integer, null: false, default: 0
    add_index :aml_clients, :orders_count
  end
end
