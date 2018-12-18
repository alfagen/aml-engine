class AddKeyToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_notifications, :key, :string
  end
end
