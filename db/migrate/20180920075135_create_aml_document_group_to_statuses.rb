class CreateAMLDocumentGroupToStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_document_group_to_statuses do |t|
      t.references :aml_document_group, foreign_key: true, null: false
      t.references :aml_status, foreign_key: true, null: false
    end

    add_index :aml_document_group_to_statuses, [:aml_document_group_id, :aml_status_id], unique: true, name: :aml_dgts_uniq
  end
end
