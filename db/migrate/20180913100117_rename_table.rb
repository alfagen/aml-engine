class RenameTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :aml_client_document_fields, :aml_document_fields
  end
end
