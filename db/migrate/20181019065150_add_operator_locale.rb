class AddOperatorLocale < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_operators, :locale, :string, default: 'ru', null: false
    execute "update aml_operators set locale='ru'"
  end
end
