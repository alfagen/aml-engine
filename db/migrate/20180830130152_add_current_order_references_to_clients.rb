class AddCurrentOrderReferencesToClients < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_clients, :aml_order, foreign_key: { on_delete: :nullify }
  end
end
