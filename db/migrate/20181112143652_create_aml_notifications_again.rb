class CreateAMLNotificationsAgain < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_notifications do |t|
      t.string :title, null: false

      t.timestamps
    end

    add_index :aml_notifications, :title, unique: true

    add_reference :aml_notification_templates, :aml_notification

    AML::NotificationTemplate.find_each do |nt|
      n = AML::Notification.find_or_create_by(title: nt.key)
      nt.update aml_notification: n
    end

    change_column_default :aml_notification_templates, :aml_notification_id, false
    remove_column :aml_notification_templates, :key


    remove_index :aml_notification_templates, :locale
    add_index :aml_notification_templates, [:aml_notification_id, :locale], unique: true, name: :aml_notification_templates_uniq
  end
end
