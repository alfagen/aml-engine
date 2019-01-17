class AddOrdersCountToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_clients, :orders_count, :integer, null: false, default: 0

    AML::Client.find_each do |c|
      c.update orders_count: c.orders.count
    end unless Rails.env.test?
  end
end
