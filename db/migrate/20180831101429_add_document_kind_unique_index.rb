class AddDocumentKindUniqueIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :aml_client_documents, [:order_id, :document_kind_id], unique: true
  end
end
