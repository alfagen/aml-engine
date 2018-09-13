# This migration comes from aml (originally 20180909174004)
class CreateAMLDocumentGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_document_groups do |t|
      t.string :title, null: false
      t.text :details
      t.integer :position
      t.timestamp :archived_at

      t.timestamps
    end

    add_reference :aml_document_kinds, :aml_document_group
  end
end
