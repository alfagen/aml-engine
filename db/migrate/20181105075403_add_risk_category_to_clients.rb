class AddRiskCategoryToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_clients, :risk_category, :char
  end
end
