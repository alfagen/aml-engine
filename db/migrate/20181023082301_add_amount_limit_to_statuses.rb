class AddAmountLimitToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_monetize :aml_statuses, :max_amount_limit
    add_column :aml_statuses, :operations_count_limit, :integer, null: false, default: 0
  end
end
