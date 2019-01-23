class OrderIncomeLimitToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_monetize :aml_statuses, :order_income_limit_amount
    change_column_default :aml_statuses, :order_income_limit_amount_currency, 'EUR'
    change_column_default :aml_statuses, :order_income_limit_amount_cents, 0
    change_column_null :aml_statuses, :order_income_limit_amount_cents, false
  end
end
