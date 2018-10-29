class AddTotalIncomeAmountToClients < ActiveRecord::Migration[5.2]
  def change
    add_monetize :aml_clients, :total_income_amount
    add_column :aml_clients, :total_operations_count, :integer, null: false, default: 0

    execute 'update aml_clients set total_income_amount_cents = 0'
    change_column_default :aml_clients, :total_income_amount_cents, 0
    change_column_null :aml_clients, :total_income_amount_cents, false
    change_column_default :aml_clients, :total_income_amount_currency, 'eur'
    change_column_null :aml_clients, :total_income_amount_currency, false
  end
end
