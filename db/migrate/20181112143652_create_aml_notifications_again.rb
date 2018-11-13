# This migration comes from aml (originally 20181112143652)
class CreateAMLNotificationsAgain < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_notifications do |t|
      t.string :title, null: false

      t.timestamps
    end

    add_index :aml_notifications, :title, unique: true

    add_reference :aml_notification_templates, :aml_notification

    remove_index :aml_notification_templates, name: :index_aml_notification_templates_on_key_and_locale

    AML::Notification.reset_column_information
    AML::NotificationTemplate.reset_column_information
    change_column_null :aml_notification_templates, :key, true
    migrate_notifications
    remove_column :aml_notification_templates, :key

    change_column_default :aml_notification_templates, :aml_notification_id, false

    add_index :aml_notification_templates, [:aml_notification_id, :locale], unique: true, name: :aml_notification_templates_uniq
  end

  private

  def migrate_notifications
    AML::Notification.delete_all
    AML::NotificationTemplate.find_each do |nt|
      if nt.key.present?
        n = AML::Notification.find_or_create_by(title: nt.key)
        nt.update_column :aml_notification_id, n
      end
    end
  end
end
