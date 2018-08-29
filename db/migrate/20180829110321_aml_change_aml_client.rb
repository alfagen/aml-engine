class AmlChangeAmlClient < ActiveRecord::Migration[5.2]
  def up
    remove_column :aml_clients, :inn
    change_column :aml_clients, :name, :string, null: true
    rename_column :aml_clients, :name, :first_name

    add_column :aml_clients, :surname, :string
    add_column :aml_clients, :patronymic, :string

    add_column :aml_clients, :workflow_state, :string, default: 'none', null: false

    change_column_null :aml_orders, :first_name, true
    change_column_null :aml_orders, :surname, true
    change_column_null :aml_orders, :patronymic, true
    change_column_null :aml_orders, :birth_date, true

    add_column :aml_clients, :birth_date, :date
    add_column :aml_document_kinds, :archived_at, :timestamp
    add_column :aml_orders, :archived_at, :timestamp
    change_column_null :aml_client_documents, :image, true
  end

  def down
  end
end
