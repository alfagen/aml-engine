class AddStatusToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_orders, :aml_status, foreign_key: true
  end
end
