class AddLocaleToAMLClient < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_clients, :locale, :string
  end
end
