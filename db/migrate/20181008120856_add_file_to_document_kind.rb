class AddFileToDocumentKind < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_document_kinds, :file, :string
    add_column :aml_document_kinds, :file_title, :string
  end
end
