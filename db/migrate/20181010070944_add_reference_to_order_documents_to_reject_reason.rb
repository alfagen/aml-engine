class AddReferenceToOrderDocumentsToRejectReason < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_order_documents, :aml_reject_reason
    add_column :aml_reject_reasons, :kind, :integer, null: false
    add_column :aml_order_documents, :reject_reason_details, :text
  end
end
