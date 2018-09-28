class SetNullFalseToPositionsInAMLStatuses < ActiveRecord::Migration[5.2]
  def change
    AML::Status.all.each_with_index do |s, index|
      s.update position: index
    end

    change_column_null :aml_statuses, :position, false
  end
end
