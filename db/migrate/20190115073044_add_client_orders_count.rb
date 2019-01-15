class AddClientOrdersCount < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_clients, :orders_count, :integer, default: 0, index: true

    AML::Client.find_each { |client| Client.reset_counters(client.id, :orders) }
  end
end
