class AddCoutnToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :orders_count, :integer, default: 0
    add_index :aml_orders, :orders_count

    AML::Order.find_each { |order| order.update(orders_count: order.client.orders_count)}
  end
end
