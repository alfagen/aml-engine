class AddStatusToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_orders, :aml_status, foreign_key: true

    AML::Order.update_all aml_status: AML.default_status if AML::Status.any?
  end
end
