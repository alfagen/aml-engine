class AddUniqueIndexToAMLClientInfo < ActiveRecord::Migration[5.2]
  def change
    add_index :aml_client_infos, :aml_client_id, unique: true, name: :index_aml_client_infos_on_aml_client_id_uniq
    remove_index :aml_client_infos, name: :index_aml_client_infos_on_aml_client_id
  end
end
