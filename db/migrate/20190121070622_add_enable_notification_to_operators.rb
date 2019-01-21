class AddEnableNotificationToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_operators, :enable_notification, :boolean, null: false, default: true
  end
end
