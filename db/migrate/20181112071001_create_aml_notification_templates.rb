class CreateAMLNotificationTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_notifications do |t|
      t.string :key, null: false
      t.string :locale, null: false
      t.string :template_id
      t.string :subject

      t.timestamps
    end

    add_index :aml_notifications, [:key, :locale], unique: true
  end
end
