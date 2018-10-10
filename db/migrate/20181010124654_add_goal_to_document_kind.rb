class AddGoalToDocumentKind < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_document_kinds, :goal, :string
  end
end
