class AddClientOrdersCount < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_orders, :client_orders, :integer, default: 0

    AML::Order.find_each do |order|
      order.update!(client_orders: order.client.orders.count)
    end
  end
end
