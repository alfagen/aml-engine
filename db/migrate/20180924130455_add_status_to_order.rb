class AddStatusToOrder < ActiveRecord::Migration[5.2]
  def change
    AML.delete_all! true
    add_reference :aml_orders, :aml_status, foreign_key: true, null: false
  end
end
