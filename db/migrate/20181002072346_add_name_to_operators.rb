class AddNameToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_operators, :name, :string
    execute 'update aml_operators set name=email'
    change_column_null :aml_operators, :name, false
  end
end
