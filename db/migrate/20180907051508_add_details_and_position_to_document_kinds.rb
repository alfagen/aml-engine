class AddDetailsAndPositionToDocumentKinds < ActiveRecord::Migration[5.2]
  def change
    add_column :document_kinds, :details, :text
    add_column :document_kinds, :position, :integer
  end
end
