class AddClientOrdersCount < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_clients, :orders_count, :integer, default: 0
    add_index :aml_clients, :orders_count

    AML::Client.find_each { |client| AML::Client.reset_counters(client.id, :orders) }
  end
end
