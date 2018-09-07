class AddPositionToDocumentKindFieldDefinitions < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_document_kind_field_definitions, :position, :integer
  end
end
