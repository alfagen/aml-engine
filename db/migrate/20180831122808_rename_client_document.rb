class RenameClientDocument < ActiveRecord::Migration[5.2]
  def change
    rename_table :aml_client_documents, :aml_order_documents
    rename_column :aml_client_document_fields, :client_document_id, :order_document_id
  end
end
