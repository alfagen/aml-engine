class MigrateCardRequiredToDocumentGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :aml_orders, :card_image
    remove_column :aml_statuses, :card_required
    add_column :aml_document_groups, :card_required, :boolean, null: false, default: false
  end
end
