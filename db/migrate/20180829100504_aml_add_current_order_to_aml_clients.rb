class AmlAddCurrentOrderToAmlClients < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_clients, :aml_current_order, foreign_key: { to_table: :aml_orders }
    add_reference :cms_users, :aml_client #, foreign_key: { to_table: :aml_orders }
    # db/migrate/20180829100504_aml_add_current_order_to_aml_clients.rb
  end
end
