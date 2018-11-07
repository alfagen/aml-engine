class CreateAMLClientAgreements < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_client_agreements do |t|
      t.references :aml_client, foreign_key: true, null: false
      t.references :aml_agreement, foreign_key: true, null: false
      t.string :remote_ip, null: false
      t.string :locale, null: false
      t.text :user_agent, null: false

      t.timestamps
    end

    add_index :aml_client_agreements, [:aml_client_id, :aml_agreement_id], unique: true, name: :aml_client_agreements_idx
  end
end
