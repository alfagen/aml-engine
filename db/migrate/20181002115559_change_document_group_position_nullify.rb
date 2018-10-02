class ChangeDocumentGroupPositionNullify < ActiveRecord::Migration[5.2]
  def change
    position = 0
    AML::DocumentGroup.order(:id).find_each do |dg|
      dg.update_column :position, position +=1
    end
    change_column_null :aml_document_groups, :position, false
  end
end
