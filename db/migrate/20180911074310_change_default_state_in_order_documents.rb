class ChangeDefaultStateInOrderDocuments < ActiveRecord::Migration[5.2]
  def change
    change_column_default :aml_order_documents, :workflow_state, 'none'
  end
end
