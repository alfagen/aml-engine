class RenameEmailAndNameInOperators < ActiveRecord::Migration[5.2]
  def change
    rename_column :aml_operators, :email, :legacy_email
    rename_column :aml_operators, :name, :legacy_name

    change_column_null :aml_operators, :legacy_email, true
    change_column_null :aml_operators, :legacy_name, true
  end
end
