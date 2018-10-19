class AddOperatorLocale < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_operators, :locale, :string, default: 'Ru'
    execute "update aml_operators set locale='Ru'"
    change_column_null :aml_operators, :locale, false
  end
end
